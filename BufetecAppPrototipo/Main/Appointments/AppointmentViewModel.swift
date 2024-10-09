import SwiftUI

class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var attorneys: [String: AttorneyBasic] = [:]
    @Published var clients: [String: UserBasic] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = APIURL.default
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    // New generic request function
    private func performRequest<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchAppointments(userId: String, userType: String) {
        isLoading = true
        errorMessage = nil
        
        performRequest(endpoint: "getAppointments?userId=\(userId)&userType=\(userType)") { (result: Result<[Appointment], Error>) in
            self.isLoading = false
            switch result {
            case .success(let fetchedAppointments):
                self.appointments = fetchedAppointments
                if userType == "cliente" {
                    self.fetchAttorneyInfo()
                } else {
                    self.fetchClientInfo()
                }
            case .failure(let error):
                self.errorMessage = "Error fetching appointments: \(error.localizedDescription)"
            }
        }
    }
    
    private func fetchAttorneyInfo() {
        let attorneyUids = Set(appointments.map { $0.abogadoUid })
        fetchUserInfo(uids: attorneyUids, userType: "attorney")
    }
    
    private func fetchClientInfo() {
        let clientUids = Set(appointments.map { $0.clienteUid })
        fetchUserInfo(uids: clientUids, userType: "client")
    }
    
    private func fetchUserInfo(uids: Set<String>, userType: String) {
        let group = DispatchGroup()
        
        for uid in uids {
            group.enter()
            
            if userType == "attorney" {
                performRequest(endpoint: "getUser?uid=\(uid)") { (result: Result<AttorneyBasic, Error>) in
                    defer { group.leave() }
                    switch result {
                    case .success(let attorney):
                        DispatchQueue.main.async {
                            self.attorneys[uid] = attorney
                        }
                    case .failure(let error):
                        print("Error fetching attorney data for \(uid): \(error)")
                    }
                }
            } else {
                performRequest(endpoint: "getUser?uid=\(uid)") { (result: Result<UserBasic, Error>) in
                    defer { group.leave() }
                    switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.clients[uid] = user
                        }
                    case .failure(let error):
                        print("Error fetching client data for \(uid): \(error)")
                    }
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func updateAppointmentStatus(appointmentId: String, newStatus: String, userId: String, userType: String, completion: @escaping (Bool) -> Void) {
        let updateData: [String: Any] = [
            "_id": appointmentId,
            "estado": newStatus
        ]
        
        performRequest(endpoint: "updateAppointment", method: "PUT", body: updateData) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                self.fetchAppointments(userId: userId, userType: userType)
                completion(true)
            case .failure(let error):
                self.errorMessage = "Error updating appointment: \(error.localizedDescription)"
                completion(false)
            }
        }
    }
    
    func cancelAppointment(appointmentId: String, userId: String, userType: String, completion: @escaping (Bool) -> Void) {
        let updateData: [String: Any] = ["_id": appointmentId]
        
        performRequest(endpoint: "cancelAppointment", method: "PUT", body: updateData) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                self.fetchAppointments(userId: userId, userType: userType)
                completion(true)
            case .failure(let error):
                self.errorMessage = "Error cancelling appointment: \(error.localizedDescription)"
                completion(false)
            }
        }
    }
    
    func deleteAppointment(appointmentId: String, userId: String, userType: String, completion: @escaping (Bool) -> Void) {
        let deleteData: [String: Any] = ["_id": appointmentId]
        
        performRequest(endpoint: "deleteAppointment", method: "DELETE", body: deleteData) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                self.fetchAppointments(userId: userId, userType: userType)
                completion(true)
            case .failure(let error):
                self.errorMessage = "Error deleting appointment: \(error.localizedDescription)"
                completion(false)
            }
        }
    }
}

// Helper struct for empty responses
struct EmptyResponse: Codable {}
