//
//  AppointmentViewModel.swift
//  BufetecAppPrototipo
//
//  Created by Ramiro Uziel Rodriguez Pineda on 08/10/24.
//

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
    
    func fetchAppointments(userId: String, userType: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/getAppointments?userId=\(userId)&userType=\(userType)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                    self.appointments = try decoder.decode([Appointment].self, from: data)
                    if userType == "cliente" {
                        self.fetchAttorneyInfo()
                    } else {
                        self.fetchClientInfo()
                    }
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("Decoding error details: \(error)")
                }
            }
        }.resume()
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
            guard let url = URL(string: "\(baseURL)/getUser?uid=\(uid)") else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                defer { group.leave() }
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received for user: \(uid)")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                    
                    if userType == "attorney" {
                        let attorney = try decoder.decode(AttorneyBasic.self, from: data)
                        DispatchQueue.main.async {
                            self.attorneys[uid] = attorney
                        }
                    } else {
                        let user = try decoder.decode(UserBasic.self, from: data)
                        DispatchQueue.main.async {
                            self.clients[uid] = user
                        }
                    }
                } catch {
                    print("Error decoding user data for \(uid): \(error)")
                }
            }.resume()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
}
