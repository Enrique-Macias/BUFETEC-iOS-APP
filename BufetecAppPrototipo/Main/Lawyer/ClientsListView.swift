import SwiftUI
import Kingfisher

struct ClientsListView: View {
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
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Buscar clientes", text: $searchText)
        }
        .padding(10)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
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
                ForEach(filteredClients, id: \.name) { client in
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
            return lhs.caseNumber < rhs.caseNumber
        case .caseType:
            return lhs.caseType < rhs.caseType
        }
    }
}

struct CustomCardClient: View {
    let client: Client
    @Binding var isManaging: Bool
    @State private var isSelected = false
    
    var body: some View {
        NavigationLink(destination: ClientProfileView()) {
            HStack(spacing: 15) {
                if isManaging {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                        .onTapGesture {
                            isSelected.toggle()
                        }
                }
                
                KFImage(URL(string: client.imageURL))
                    .placeholder { Image(systemName: "person.crop.circle.fill").font(.largeTitle) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(client.name)
                        .font(.headline)
                    Text(client.caseNumber)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(client.caseType)
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
        .buttonStyle(PlainButtonStyle()) // This ensures the button doesn't have default styling
    }
}

struct Client: Identifiable {
    let id = UUID()
    let name: String
    let caseNumber: String
    let caseType: String
    let imageURL: String
}

private enum SortOption: String, CaseIterable {
    case caseName = "Nombre"
    case caseNumber = "Número de caso"
    case caseType = "Tipo de caso"
}

// Sample data
let clients = [
    Client(name: "Stephan Guy", caseNumber: "#153a", caseType: "Caso civil", imageURL: "https://example.com/image1.jpg"),
    Client(name: "Guy Stephani", caseNumber: "#153b", caseType: "Caso familiar", imageURL: "https://example.com/image2.jpg"),
    // Add more clients here...
]

#Preview {
    ClientsListView()
}
