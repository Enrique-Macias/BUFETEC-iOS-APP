//
//  AttorneyCard.swift
//  BufetecAppPrototipo
//
//  Created by Ramiro Uziel Rodriguez Pineda on 08/10/24.
//




class AttorneysViewModel: ObservableObject {
    @Published var attorneys: [Attorney] = []
    private let baseURL = APIURL.default
    
    func fetchAttorneys() {
        guard let url = URL(string: "\(baseURL)/getAttorneys") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use custom date decoding strategy
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let fetchedAttorneys = try decoder.decode([Attorney].self, from: data)
                DispatchQueue.main.async {
                    self.attorneys = fetchedAttorneys
                }
            } catch {
                print("Error decoding attorneys: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context)")
                    default:
                        print("Decoding error: \(decodingError)")
                    }
                }
            }
        }.resume()
    }
}
