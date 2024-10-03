import SwiftUI

struct ClientProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                caseInfoCard
                datesSection
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
                Text("Stephan Guy")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(.primary)
                
                HStack {
                    Text("#902a")
                        .font(.custom("Poppins", size: 14))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("Cliente")
                        .font(.custom("Poppins", size: 14))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(uiImage: UIImage(named: "placeholderProfileImage") ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    var caseInfoCard: some View {
        HStack {
            infoItem(title: "Caso", value: "Mercantil")
            Divider().frame(height: 30)
            infoItem(title: "Estado", value: "En proceso")
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
            Text("Fechas")
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
            
            detailItem(title: "Descripción del cliente", content: "Estoy enfrentando un problema legal con un cliente que no ha cumplido con el pago de una factura por servicios prestados. He intentado varias veces comunicarme con ellos, pero no he recibido respuesta. Necesito orientación sobre cómo proceder bajo la ley mercantil para recuperar el monto adeudado.")
            
            detailItem(title: "Evaluación del asistente al cliente", content: "Te recomiendo informar de inmediato a nuestro abogado asesor sobre tu situación de incumplimiento de pago, ya que este es un caso de derecho mercantil. Ellos podrán guiarte sobre los pasos legales a seguir para resolver tu caso y asegurarte de que recibas el apoyo necesario para proteger tus derechos.")
        }
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
        ClientProfileView()
    }
}
