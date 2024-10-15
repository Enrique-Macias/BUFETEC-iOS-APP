import SwiftUI

struct ClientProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    var client: Client // Accepting the client
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                caseInfoCard
                detailsSection
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Perfil del Cliente")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var profileHeader: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text(client.name) // Using client name
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(.primary)
                
                HStack {
                    Text(client.exp)
                        .font(.custom("Poppins", size: 14))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text(client.juzgado)
                        .font(.custom("Poppins", size: 14))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .foregroundStyle(Color.accentColor)
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    var caseInfoCard: some View {
        HStack {
            infoItem(title: "Trámite", value: client.tram)
            Divider()
                .frame(height: 30)
            
            VStack(){
                infoItem(title: "Correo", value: client.email)
                infoItem(title: "Número", value: client.numero)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    func infoItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(.secondary)
            Text(value)
                .font(.custom("Poppins", size: 16))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var datesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Citas Previas")
                .font(.custom("Poppins-Bold", size: 20))
                .padding(.bottom, 5)
            
            ForEach(dateItems, id: \.title) { item in
                dateItemView(item: item)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    func dateItemView(item: DateItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                Text(item.date)
                    .font(.custom("Poppins", size: 14))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(item.status)
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(item.status == "Completa" ? .green : .orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(item.status == "Completa" ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                .cornerRadius(10)
        }
        .padding(.vertical, 5)
    }
    
    var detailsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detalles")
                .font(.custom("Poppins-Bold", size: 20))
            
            detailItem(title: "Seguimiento", content: client.seguimiento)
        }
        .frame(maxWidth: .infinity, minHeight: 220, alignment: .topLeading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    func detailItem(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 16))
            Text(content)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.secondary)
        }
    }
}

struct DateItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let status: String
}

let dateItems = [
    DateItem(title: "Reunión con asesor", date: "01/01/2024", status: "Completa"),
    DateItem(title: "Presentación de demanda", date: "01/01/2024", status: "Pendiente")
]

#Preview {
    NavigationView {
        ClientProfileView(client: Client(name: "Stephan Guy", exp: "376/2023", tram: "Mercantil", email: "example@example.com", seguimiento: "En proceso", alumno: "Alumno 1", folio: "#902a", ultimaVezInformada: "01/01/2024", juzgado: "Juzgado 4o",numero:"8100000000"))
    }
}
