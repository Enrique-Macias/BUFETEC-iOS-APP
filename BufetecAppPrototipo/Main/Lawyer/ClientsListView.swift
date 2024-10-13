import SwiftUI

struct ClientsListView: View {
    @State private var clients: [Client] = []
    @State private var searchText = ""
    @State private var isManaging = false
    @State private var sortOption = SortOption.caseName

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                filterButtons
                clientList
            }
        }
        .navigationTitle("Clientes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isManaging.toggle() }) {
                    Text(isManaging ? "Listo" : "Administrar")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear(perform: fetchClients)
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Buscar clientes", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
        .padding(.top)
    }

    private var filterButtons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: { sortOption = option }) {
                        Text(option.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(sortOption == option ? Color.accentColor : Color(UIColor.systemGray5))
                            .foregroundColor(sortOption == option ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding()
        }
    }

    private var clientList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(filteredClients, id: \.id) { client in
                    CustomCardClient(client: client, isManaging: $isManaging)
                }
            }
            .padding()
        }
    }

    private var filteredClients: [Client] {
        clients.filter { client in
            searchText.isEmpty || client.name.localizedCaseInsensitiveContains(searchText)
        }.sorted { sortClient($0, isLessThan: $1) }
    }

    private func sortClient(_ lhs: Client, isLessThan rhs: Client) -> Bool {
        switch sortOption {
        case .caseName:
            return lhs.name < rhs.name
        case .caseNumber:
            return lhs.exp < rhs.exp
        case .caseType:
            return lhs.tram < rhs.tram
        }
    }

    private func fetchClients() {
        guard let url = URL(string: "https://buffetec-api.vercel.app/getClientsFromSheets") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching clients: \(error)")
                return
            }

            guard let data = data else { return }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    DispatchQueue.main.async {
                        clients = jsonArray.compactMap { dict in
                            let name = (dict["nombre"] as? String) ?? "n/a"
                            let expedienteYJuzgado = (dict["expediente_y_juzgado"] as? String) ?? "n/a"
                            let tramite = (dict["tramite"] as? String) ?? "n/a"
                            let email = (dict["correo"] as? String) ?? "n/a"
                            let seguimiento = (dict["seguimiento"] as? String) ?? "n/a"
                            let alumno = (dict["alumno"] as? String) ?? "n/a"
                            let folio = (dict["folio"] as? String) ?? "n/a"
                            let ultimaVezInformada = (dict["ultima_vez_informada"] as? String) ?? "n/a"

                            // Extracting expediente and juzgado
                            let components = expedienteYJuzgado.components(separatedBy: "Juzgado")
                            let expediente = components.first?.trimmingCharacters(in: .whitespaces) ?? "n/a"
                            let juzgado = components.count > 1 ? "Juzgado " + components[1].trimmingCharacters(in: .whitespaces) : "n/a"
                            
                            return Client(name: name, exp: expediente, tram: tramite, email: email, seguimiento: seguimiento, alumno: alumno, folio: folio, ultimaVezInformada: ultimaVezInformada, juzgado: juzgado)
                        }
                        print("Fetched \(clients.count) clients.") 
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }.resume()
    }

}

struct CustomCardClient: View {
    let client: Client
    @Binding var isManaging: Bool
    @State private var isSelected = false

    var body: some View {
        NavigationLink(destination: ClientProfileView(client: client)) {
            HStack(spacing: 15) {
                if isManaging {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                        .onTapGesture {
                            isSelected.toggle()
                        }
                }

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 4) {
                    Text(client.name)
                        .font(.headline)
                    Text(client.exp)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(client.tram)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
            
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.accentColor)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Client: Identifiable {
    let id = UUID()
    let name: String
    let exp: String
    let tram: String
    let email: String
    let seguimiento: String
    let alumno: String
    let folio: String
    let ultimaVezInformada: String
    let juzgado: String // New property for juzgado
}

private enum SortOption: String, CaseIterable {
    case caseName = "Nombre"
    case caseNumber = "Número de caso"
    case caseType = "Tipo de caso"
}

#Preview {
    ClientsListView()
}
