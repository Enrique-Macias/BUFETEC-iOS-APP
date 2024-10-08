import SwiftUI

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
                        Text(attorney.nombre)
                            .font(CustomFonts.PoppinsBold(size: 16))
                            .foregroundColor(Color("btBlue"))
                        Text(attorney.especialidad)
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
                    descriptionSection("Descripción:", text: attorney.descripcion)
                    descriptionSection("Horario:", text: formatSchedule(attorney.horarioSemanal))
                    descriptionSection("Ejemplos de Casos:", text: attorney.casosEjemplo)
                    
                    NavigationLink(destination: CreateAppointmentView(attorney: attorney)) {
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
    
    private func formatSchedule(_ schedule: [String: [String]]) -> String {
        let days = [
            "lun": "Lunes",
            "mar": "Martes",
            "mie": "Miércoles",
            "jue": "Jueves",
            "vie": "Viernes",
            "sab": "Sábado",
            "dom": "Domingo"
        ]
        
        return schedule.map { key, value in
            let dayName = days[key] ?? key
            let hours = value.joined(separator: ", ")
            return "\(dayName): \(hours)"
        }.joined(separator: "\n")
    }
}

struct AttorneysListView: View {
    @StateObject private var viewModel = AttorneysViewModel()
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
        .onAppear {
            viewModel.fetchAttorneys()
        }
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
                    filterButton(for: option)
                }
            }
            .padding()
        }
    }
    
    private func filterButton(for option: SortOption) -> some View {
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
    
    private var attorneyList: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if filteredAttorneys.isEmpty {
                VStack {
                    Spacer()
                    Text("No hay abogados registrados.")
                        .font(CustomFonts.MontserratMedium(size: 16))
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                }
                .frame(minHeight: 200)
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(filteredAttorneys) { attorney in
                        AttorneyCard(attorney: attorney)
                    }
                }
                .padding()
            }
        }
    }
    
    private var filteredAttorneys: [Attorney] {
        viewModel.attorneys.filter { attorney in
            searchText.isEmpty || attorney.nombre.localizedCaseInsensitiveContains(searchText) || attorney.especialidad.localizedCaseInsensitiveContains(searchText)
        }.sorted { sortAttorney($0, isLessThan: $1) }
    }
    
    private func sortAttorney(_ lhs: Attorney, isLessThan rhs: Attorney) -> Bool {
        switch sortOption {
        case .caseName:
            return lhs.nombre < rhs.nombre
        case .specialty:
            return lhs.especialidad < rhs.especialidad
        }
    }
}

private enum SortOption: String, CaseIterable {
    case caseName = "Nombre"
    case specialty = "Especialidad"
}
