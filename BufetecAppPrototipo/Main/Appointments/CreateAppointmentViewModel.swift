class CreateAppointmentViewModel: ObservableObject {
    @Published var availability: [Date: [String]] = [:]
    @Published var isDateAvailable = false
    @Published var availableTimes: [String] = []
    
    private let baseURL = APIURL.default
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    func fetchAvailability(for attorney: Attorney, month: Date) {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: month)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let weekday = calendar.component(.weekday, from: date)
                let weekdayKey = ["dom", "lun", "mar", "mie", "jue", "vie", "sab"][weekday - 1]
                
                if let availableHours = attorney.horarioSemanal[weekdayKey] {
                    let startOfDay = calendar.startOfDay(for: date)
                    let exceptionsForDay = attorney.excepcionesFechas.filter {
                        calendar.isDate($0.fechaHora, inSameDayAs: date)
                    }
                    
                    var availableTimesForDay = availableHours
                    
                    for exception in exceptionsForDay {
                        let exceptionHour = calendar.component(.hour, from: exception.fechaHora)
                        let exceptionMinute = calendar.component(.minute, from: exception.fechaHora)
                        let exceptionTimeString = String(format: "%02d:%02d", exceptionHour, exceptionMinute)
                        availableTimesForDay.removeAll { $0 == exceptionTimeString }
                    }
                    
                    availability[startOfDay] = availableTimesForDay
                } else {
                    availability[calendar.startOfDay(for: date)] = []
                }
            }
        }
    }
    
    func handleDateChange(for date: Date, attorney: Attorney) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        if let availableTimesForDay = availability[startOfDay] {
            availableTimes = availableTimesForDay
            isDateAvailable = !availableTimes.isEmpty
        } else {
            isDateAvailable = false
            availableTimes = []
        }
    }
    
    func createAppointment(abogadoUid: String, clienteUid: String, fecha: Date, hora: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/createAppointment") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let calendar = Calendar.current
        let timeComponents = hora.split(separator: ":").compactMap { Int($0) }
        guard timeComponents.count == 2 else {
            completion(.failure(NSError(domain: "Invalid time format", code: 0, userInfo: nil)))
            return
        }
        
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: fecha)
        dateComponents.hour = timeComponents[0]
        dateComponents.minute = timeComponents[1]
        
        guard let combinedDate = calendar.date(from: dateComponents) else {
            completion(.failure(NSError(domain: "Failed to create date", code: 0, userInfo: nil)))
            return
        }
        
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fechaString = iso8601Formatter.string(from: combinedDate)
        
        let appointmentData: [String: Any] = [
            "abogadoUid": abogadoUid,
            "clienteUid": clienteUid,
            "fechaHora": fechaString,
            "estado": "pendiente",
            "notas": "Cita agendada a través de la aplicación"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: appointmentData)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }.resume()
    }
}
