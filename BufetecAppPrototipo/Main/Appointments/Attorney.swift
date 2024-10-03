import Foundation

struct Attorney: Codable, Identifiable {
    let id: String
    let uid: String
    let nombre: String
    let celular: String
    let email: String
    let especialidad: String
    let descripcion: String
    let horarioSemanal: [String: [String]]
    let duracionCita: Int
    let casosEjemplo: String
    let excepcionesFechas: [ExcepcionFecha]
    let createdAt: Date
    let updatedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case uid, nombre, celular, email, especialidad, descripcion, horarioSemanal, duracionCita, casosEjemplo, excepcionesFechas, createdAt, updatedAt
    }
    
    struct ExcepcionFecha: Codable {
        let fechaHora: Date
        let razon: String
        
        private enum CodingKeys: String, CodingKey {
            case fechaHora = "fechaHora"
            case razon
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let dateString = try container.decode(String.self, forKey: .fechaHora)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            guard let date = dateFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(forKey: .fechaHora, in: container, debugDescription: "Expected date string to be in format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.")
            }
            self.fechaHora = date
            self.razon = try container.decode(String.self, forKey: .razon)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let dateString = dateFormatter.string(from: fechaHora)
            try container.encode(dateString, forKey: .fechaHora)
            try container.encode(razon, forKey: .razon)
        }
    }
}
