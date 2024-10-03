import SwiftUI

struct AttorneysListView: View {
    @State private var searchText = ""
    @State private var sortOption = SortOption.caseName
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                filterButtons
                attorneyList
            }
        }
        .navigationTitle("Nuestros Abogados")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Buscar abogados", text: $searchText)
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
                            .font(CustomFonts.MontserratMedium(size: 12))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(sortOption == option ? Color("btBlue") : Color(UIColor.systemGray5))
                            .foregroundColor(sortOption == option ? .white : Color("btBlue"))
                            .cornerRadius(20)
                    }
                }
            }
            .padding()
        }
    }
    
    private var attorneyList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(filteredAttorneys) { attorney in
                    AttorneyCard(attorney: attorney)
                }
            }
            .padding()
        }
    }
    
    private var filteredAttorneys: [Attorney] {
        attorneys.filter { attorney in
            searchText.isEmpty || attorney.name.localizedCaseInsensitiveContains(searchText) || attorney.specialty.localizedCaseInsensitiveContains(searchText)
        }.sorted { sortAttorney($0, isLessThan: $1) }
    }
    
    private func sortAttorney(_ lhs: Attorney, isLessThan rhs: Attorney) -> Bool {
        switch sortOption {
        case .caseName:
            return lhs.name < rhs.name
        case .specialty:
            return lhs.specialty < rhs.specialty
        }
    }
}

struct AttorneyCard: View {
    let attorney: Attorney
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("btBlue"))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(attorney.name)
                            .font(CustomFonts.PoppinsBold(size: 16))
                            .foregroundColor(Color("btBlue"))
                        Text(attorney.specialty)
                            .font(CustomFonts.MontserratMedium(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("btBlue"))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    descriptionSection("Descripción:", text: attorney.description)
                    descriptionSection("Horario:", text: attorney.schedule)
                    descriptionSection("Ejemplos de Casos:", text: attorney.examples)
                    
                    Button(action: {
                        // Acción para agendar cita
                    }) {
                        HStack {
                            Text("Agendar Cita")
                                .font(CustomFonts.PoppinsSemiBold(size: 12))
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("btBlue"))
                        .cornerRadius(15)
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 15)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func descriptionSection(_ title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(CustomFonts.PoppinsBold(size: 14))
                .foregroundColor(Color("btBlue"))
            Text(text)
                .font(CustomFonts.MontserratMedium(size: 14))
                .foregroundColor(.black)
        }
    }
}

struct Attorney: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let description: String
    let schedule: String
    let examples: String
}

private enum SortOption: String, CaseIterable {
    case caseName = "Nombre"
    case specialty = "Especialidad"
}

// Sample data
let attorneys = [
    Attorney(
        name: "Vibiana Agramont",
        specialty: "Abogada Civil y Mercantil",
        description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its It is a long established fact that a reader...",
        schedule: "Lunes, Miércoles y Jueves de 1 a 5 P.M.",
        examples: "It is a long established fact that a reader will be distracted by the readable..."
    ),
    Attorney(
        name: "Manolo Martínez",
        specialty: "Abogado Familiar",
        description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its It is a long established fact that a reader...",
        schedule: "Lunes, Miércoles y Jueves de 1 a 5 P.M.",
        examples: "It is a long established fact that a reader will be distracted by the readable..."
    ),
    Attorney(
        name: "Verónica González",
        specialty: "Abogado Familiar",
        description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its It is a long established fact that a reader...",
        schedule: "Lunes, Miércoles y Jueves de 1 a 5 P.M.",
        examples: "It is a long established fact that a reader will be distracted by the readable..."
    )
]

#Preview {
    AttorneysListView()
}
