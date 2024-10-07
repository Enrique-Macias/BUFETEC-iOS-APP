import SwiftUI

struct CalendarDay: Identifiable {
    let date: Date
    let id: UUID
}

struct AppointmentCardInfo: View {
    let name: String
    let specialty: String
    let phoneNumber: String
    let email: String
    let address: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            contactInfo
            addressInfo
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("btBlue"), lineWidth: 1)
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(CustomFonts.PoppinsBold(size: 20))
                    .foregroundColor(Color("btBlue"))
                
                Text(specialty)
                    .font(CustomFonts.MontserratMedium(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color("btBlue"))
                .offset(y: 3)
        }
    }
    
    private var contactInfo: some View {
        HStack(spacing: 10) {
            contactInfoItem(icon: "phone.fill", text: phoneNumber)
            contactInfoItem(icon: "envelope.fill", text: email)
        }
    }
    
    private func contactInfoItem(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
            Text(text)
        }
        .font(CustomFonts.MontserratBold(size: 12))
        .foregroundColor(Color("btBlue"))
    }
    
    private var addressInfo: some View {
        HStack(spacing: 5) {
            Image(systemName: "mappin.and.ellipse")
            Text(address)
                .font(CustomFonts.MontserratMedium(size: 12))
        }
        .foregroundColor(Color("btBlue"))
    }
}

struct ConfirmationAlertView: View {
    let name: String
    let selectedDate: Date
    let selectedTime: String
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
            
            Text("Cita Confirmada")
                .font(CustomFonts.PoppinsBold(size: 20))
                .foregroundColor(.primary)
            
            Text("Tu cita con \(name) ha sido confirmada")
                .font(CustomFonts.MontserratRegular(size: 14))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            HStack {
                HStack {
                    Image(systemName: "calendar")
                    Text("\(selectedDate, style: .date)")
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text(selectedTime)
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(.primary)
                }
            }
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("C. Av. Luis Elizondo y Garza Sada, Tecnológico, 64700 Monterrey, N.L.")
                    .font(CustomFonts.MontserratRegular(size: 12))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 10)
            
            Button(action: dismiss) {
                Text("Continuar")
                    .font(CustomFonts.PoppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("btBlue"))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct CalendarDay: Identifiable {
    let date: Date
    let id: UUID
}

struct AppointmentCardInfo: View {
    let name: String
    let specialty: String
    let phoneNumber: String
    let email: String
    let address: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            contactInfo
            addressInfo
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("btBlue"), lineWidth: 1)
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(CustomFonts.PoppinsBold(size: 20))
                    .foregroundColor(Color("btBlue"))
                
                Text(specialty)
                    .font(CustomFonts.MontserratMedium(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color("btBlue"))
                .offset(y: 3)
        }
    }
    
    private var contactInfo: some View {
        HStack(spacing: 10) {
            contactInfoItem(icon: "phone.fill", text: phoneNumber)
            contactInfoItem(icon: "envelope.fill", text: email)
        }
    }
    
    private func contactInfoItem(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
            Text(text)
        }
        .font(CustomFonts.MontserratBold(size: 12))
        .foregroundColor(Color("btBlue"))
    }
    
    private var addressInfo: some View {
        HStack(spacing: 5) {
            Image(systemName: "mappin.and.ellipse")
            Text(address)
                .font(CustomFonts.MontserratMedium(size: 12))
        }
        .foregroundColor(Color("btBlue"))
    }
}

struct ConfirmationAlertView: View {
    let name: String
    let selectedDate: Date
    let selectedTime: String
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
            
            Text("Cita Confirmada")
                .font(CustomFonts.PoppinsBold(size: 20))
                .foregroundColor(.primary)
            
            Text("Tu cita con \(name) ha sido confirmada")
                .font(CustomFonts.MontserratRegular(size: 14))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            HStack {
                HStack {
                    Image(systemName: "calendar")
                    Text("\(selectedDate, style: .date)")
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text(selectedTime)
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(.primary)
                }
            }
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("C. Av. Luis Elizondo y Garza Sada, Tecnológico, 64700 Monterrey, N.L.")
                    .font(CustomFonts.MontserratRegular(size: 12))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 10)
            
            Button(action: dismiss) {
                Text("Continuar")
                    .font(CustomFonts.PoppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("btBlue"))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct CreateAppointmentView: View {
    let attorney: Attorney
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authModel: AuthModel
    @StateObject private var viewModel = CreateAppointmentViewModel()
    
    @State private var selectedDate = Date()
    @State private var selectedTime: String? = nil
    @State private var currentMonthOffset: Int = 0
    
    @State private var showingConfirmationAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AppointmentCardInfo(
                    name: attorney.nombre,
                    specialty: attorney.especialidad,
                    phoneNumber: attorney.celular, // Add this to the Attorney model if available
                    email: attorney.email, // Add this to the Attorney model if available
                    address: "N/A" // Add this to the Attorney model if available
                )
                .padding(.horizontal, 10)
                
                calendarSection
                timeSelectionSection
                confirmButton
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("Agendar Cita")
        .alert(isPresented: $showingErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        .sheet(isPresented: $showingConfirmationAlert) {
            ConfirmationAlertView(name: attorney.nombre, selectedDate: selectedDate, selectedTime: selectedTime ?? "", dismiss: { showingConfirmationAlert = false })
        }
        .onAppear {
            viewModel.fetchAvailability(for: attorney, month: selectedDate)
        }
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Selecciona una fecha")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("btBlue"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            CustomCalendarView(
                selectedDate: $selectedDate,
                availability: viewModel.availability,
                currentMonthOffset: $currentMonthOffset,
                onDateChange: handleDateChange,
                onMonthChange: { date in
                    viewModel.fetchAvailability(for: attorney, month: date)
                }
            )
            .padding(.horizontal, 20)
        }
    }
    
    private var timeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Selecciona un horario")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("btBlue"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.isDateAvailable {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(viewModel.availableTimes, id: \.self) { time in
                        Button(action: {
                            selectedTime = (selectedTime == time) ? nil : time
                        }) {
                            Text(time)
                                .font(CustomFonts.PoppinsSemiBold(size: 16))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTime == time ? Color("btBlue") : Color.white)
                                .foregroundColor(selectedTime == time ? Color.white : Color("btBlue"))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("btBlue"), lineWidth: 1)
                                )
                        }
                    }
                }
            } else {
                Text("No hay horarios disponibles para este día.")
                    .font(CustomFonts.MontserratRegular(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var confirmButton: some View {
        Button(action: createAppointment) {
            Text("Confirmar cita")
                .font(CustomFonts.PoppinsSemiBold(size: 18))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isDateAvailable && selectedTime != nil ? Color("btBlue") : Color.gray.opacity(0.6))
                .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .disabled(!viewModel.isDateAvailable || selectedTime == nil)
    }
    
    private func handleDateChange(for date: Date) {
        viewModel.handleDateChange(for: date, attorney: attorney)
        selectedTime = nil
    }
    
    private func createAppointment() {
        guard let selectedTime = selectedTime else {
            errorMessage = "Por favor selecciona una hora para la cita."
            showingErrorAlert = true
            return
        }
        
        viewModel.createAppointment(
            abogadoUid: attorney.uid,
            clienteUid: authModel.userData.uid,
            fecha: selectedDate,
            hora: selectedTime
        ) { result in
            switch result {
            case .success:
                showingConfirmationAlert = true
            case .failure(let error):
                errorMessage = "Error al crear la cita: \(error.localizedDescription)"
                showingErrorAlert = true
            }
        }
    }
}

class CreateAppointmentViewModel: ObservableObject {
    @Published var availability: [Date: [String]] = [:]
    @Published var isDateAvailable = false
    @Published var availableTimes: [String] = []
    
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
        guard let url = URL(string: "http://localhost:3000/createAppointment") else {
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

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    var availability: [Date: [String]]
    @Binding var currentMonthOffset: Int
    var onDateChange: (Date) -> Void
    var onMonthChange: (Date) -> Void
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private let daysOfWeek = ["L", "M", "X", "J", "V", "S", "D"]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentMonthOffset -= 1
                    let newDate = getCurrentMonthDate()
                    selectedDate = newDate
                    onDateChange(selectedDate)
                    onMonthChange(newDate)
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text("\(getMonthAndYear())")
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                Button(action: {
                    currentMonthOffset += 1
                    let newDate = getCurrentMonthDate()
                    selectedDate = newDate
                    onDateChange(selectedDate)
                    onMonthChange(newDate)
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            HStack(spacing: 15) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)
            
            let days = createDaysForMonth(for: selectedDate)
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(days) { day in
                    VStack {
                        Text("\(calendar.component(.day, from: day.date))")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isPastDate(day.date) ? Color.gray.opacity(0.5) : (calendar.isDate(selectedDate, inSameDayAs: day.date) ? Color.white : Color.black))
                            .frame(width: 32, height: 32)
                            .background(isPastDate(day.date) ? Color.clear : (calendar.isDate(selectedDate, inSameDayAs: day.date) ? Color("btBlue") : Color.clear))
                            .cornerRadius(16)
                            .onTapGesture {
                                if !isPastDate(day.date) {
                                    selectedDate = day.date
                                    onDateChange(day.date)
                                }
                            }
                        
                        if !isPastDate(day.date) {
                            if let availableTimes = availability[calendar.startOfDay(for: day.date)] {
                                Circle()
                                    .fill(getAvailabilityColor(for: availableTimes))
                                    .frame(width: 8, height: 8)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getCurrentMonthDate() -> Date {
        let today = Date()
        return calendar.date(byAdding: .month, value: currentMonthOffset, to: today)!
    }
    
    private func createDaysForMonth(for date: Date) -> [CalendarDay] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        let firstDayOfMonth = calendar.component(.weekday, from: startDate)
        let leadingEmptyDays = firstDayOfMonth == 1 ? 6 : firstDayOfMonth - 2
        
        var days: [CalendarDay] = []
        
        // Add leading empty days
        for _ in 0..<leadingEmptyDays {
            days.append(CalendarDay(date: Date.distantPast, id: UUID()))
        }
        
        // Add actual days of the month
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) {
                days.append(CalendarDay(date: date, id: UUID()))
            }
        }
        
        return days
    }
    
    private func getMonthAndYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: getCurrentMonthDate())
    }
    
    private func getAvailabilityColor(for availableTimes: [String]) -> Color {
        switch availableTimes.count {
        case 5...:
            return .green
        case 1...4:
            return .green
        default:
            return .gray
        }
    }
    
    private func isPastDate(_ date: Date) -> Bool {
        return calendar.compare(date, to: Date(), toGranularity: .day) == .orderedAscending
    }
}

// Uncomment this for previews
// #Preview {
//     CreateAppointmentView(attorney: Attorney.sampleData)
//         .environmentObject(AuthModel())
// }
