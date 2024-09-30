import SwiftUI

struct AppointmentsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showingConfirmationAlert = false
    @State private var showingErrorAlert = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tintColor]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(alignment: .leading, spacing: 20) {
                        CurrentAppointmentsCard(
                            name: "Bruno García",
                            specialty: "Abogado Familiar",
                            address: "C. Av. Luis Elizondo y Garza Sada,\nTecnológico, 64700 Monterrey, N.L.",
                            reason: "Asesoría Legal",
                            date: "Vie, 7 Feb 2024",
                            hours: "10:00 - 12:00"
                        )
                        .padding(.horizontal, 10)
                        
                        // Sección de seleccionar fecha
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Citas previas")
                                .font(.system(size: 18))
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 10)
                            
                            PreviousAppointmentsCard(
                                name: "Bruno García",
                                specialty: "Abogado Familiar",
                                address: "C. Av. Luis Elizondo y Garza Sada,\nTecnológico, 64700 Monterrey, N.L.",
                                reason: "Asesoría Legal",
                                date: "Vie, 7 Feb 2024",
                                hours: "10:00 - 12:00"
                            )
                            PreviousAppointmentsCard(
                                name: "Bruno García",
                                specialty: "Abogado Familiar",
                                address: "C. Av. Luis Elizondo y Garza Sada,\nTecnológico, 64700 Monterrey, N.L.",
                                reason: "Asesoría Legal",
                                date: "Vie, 7 Feb 2024",
                                hours: "10:00 - 12:00"
                            )

                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.bottom, 40)
                    
                }
            }
            .navigationTitle("Citas")
            .navigationBarTitleDisplayMode(.inline)
        }
    }}

// Componente para la tarjeta de información del abogado
struct CurrentAppointmentsCard: View {
    let name: String
    let specialty: String
    let address: String
    let reason: String
    let date: String
    let hours: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            reasonInfo
            addressInfo
            dateTime
        }
        .padding(20)
        .background(Color("btBlue"))
        .cornerRadius(15)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(CustomFonts.PoppinsBold(size: 18))
                    .foregroundColor(Color.white)
                
                Text(specialty)
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.white)
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.white)
                .offset(y: 3)
            
        }
        .padding(.bottom, 10)
    }
    
    private var reasonInfo: some View {
        HStack(spacing: 5) {
            Text("Motivo: ")
                .font(CustomFonts.MontserratMedium(size: 12))
                .fontWeight(.black)
            Text(reason)
                .font(CustomFonts.MontserratMedium(size: 12))
        }
        .foregroundColor(Color.white)
    }
    
    
    private var addressInfo: some View {
        HStack(spacing: 5) {
            Text("Ubicación: ")
                .font(CustomFonts.MontserratMedium(size: 12))
                .fontWeight(.black)
            Text(address)
                .font(CustomFonts.MontserratMedium(size: 12))
        }
        .foregroundColor(Color.white)
    }
    
    private var dateTime: some View {
        HStack() {
            Spacer()
            Image(systemName: "calendar")
            Text(date)
                .font(CustomFonts.MontserratMedium(size: 12))
            Spacer()
            Image(systemName: "clock")
            Text(hours)
                .font(CustomFonts.MontserratMedium(size: 12))
            Spacer()
        }
        .foregroundStyle(Color("btBlue"))
        .padding(.vertical, 10)
        .frame(width: .infinity)
        .background(.white)
        .cornerRadius(10)
        .padding(.top, 10)
    }
}

// Componente para la tarjeta de información del abogado
struct PreviousAppointmentsCard: View {
    let name: String
    let specialty: String
    let address: String
    let reason: String
    let date: String
    let hours: String
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 10) {
                header
                reasonInfo
            }
            VStack(){
                Spacer()
                HStack() {
                    Spacer()
                    Image(systemName: "calendar")
                    Text(date)
                        .font(CustomFonts.MontserratMedium(size: 12))
                }
                Spacer()
                HStack() {
                    Spacer()
                    Image(systemName: "clock")
                    Text(hours)
                        .font(CustomFonts.MontserratMedium(size: 12))
                }
                Spacer()
            }
        }
        .padding(20)
        .background(Color.clear)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(CustomFonts.PoppinsBold(size: 18))
                    .foregroundColor(Color.primary)
                
                Text(specialty)
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.primary)
            }
            .frame(width: 130, alignment: .leading)
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.white)
                .offset(y: 3)
            
        }
    }
    
    private var reasonInfo: some View {
        HStack(spacing: 5) {
            Text("Motivo: ")
                .font(CustomFonts.MontserratMedium(size: 12))
                .fontWeight(.black)
            Text(reason)
                .font(CustomFonts.MontserratMedium(size: 12))
        }
        .foregroundColor(Color.primary)
    }
}

#Preview {
    AppointmentsView()
        .environment(AppearanceManager())
}
