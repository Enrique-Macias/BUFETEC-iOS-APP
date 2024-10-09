import SwiftUI

class AttorneysViewModel: ObservableObject {
    @Published var attorneys: [Attorney] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = APIURL.default
    
    func fetchAttorneys() {
        guard let url = URL(string: "\(baseURL)/getAttorneys") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let fetchedAttorneys = try decoder.decode([Attorney].self, from: data)
                    self?.attorneys = fetchedAttorneys
                } catch {
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .dataCorrupted(let context):
                            self?.errorMessage = "Data corrupted: \(context.debugDescription)"
                        case .keyNotFound(let key, let context):
                            self?.errorMessage = "Key '\(key)' not found: \(context.debugDescription)"
                        case .typeMismatch(let type, let context):
                            self?.errorMessage = "Type '\(type)' mismatch: \(context.debugDescription)"
                        case .valueNotFound(let type, let context):
                            self?.errorMessage = "Value of type '\(type)' not found: \(context.debugDescription)"
                        @unknown default:
                            self?.errorMessage = "Unknown decoding error"
                        }
                    } else {
                        self?.errorMessage = "Error decoding attorneys: \(error.localizedDescription)"
                    }
                }
            }
        }.resume()
    }
}
