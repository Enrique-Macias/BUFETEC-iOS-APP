import SwiftUI
import Foundation

struct Appointment: Identifiable, Codable {
    let id: String
    let abogadoUid: String
    let clienteUid: String
    let fechaHora: Date
    let estado: String
    let notas: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case abogadoUid, clienteUid, fechaHora, estado, notas
    }
}

struct AttorneyBasic: Codable {
    let uid: String
    let nombre: String
    let genero: String
    let celular: String
    let email: String
    let fechaDeNacimiento: Date
    let tipo: String
}

struct UserBasic: Codable {
    let uid: String
    let nombre: String
    let genero: String
    let celular: String
    let email: String
    let fechaDeNacimiento: Date
    let tipo: String
}

class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var attorneys: [String: AttorneyBasic] = [:]
    @Published var clients: [String: UserBasic] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func fetchAppointments(userId: String, userType: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "http://localhost:3000/getAppointments?userId=\(userId)&userType=\(userType)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                    self.appointments = try decoder.decode([Appointment].self, from: data)
                    if userType == "cliente" {
                        self.fetchAttorneyInfo()
                    } else {
                        self.fetchClientInfo()
                    }
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("Decoding error details: \(error)")
                }
            }
        }.resume()
    }
    
    private func fetchAttorneyInfo() {
        let attorneyUids = Set(appointments.map { $0.abogadoUid })
        fetchUserInfo(uids: attorneyUids, userType: "attorney")
    }
    
    private func fetchClientInfo() {
        let clientUids = Set(appointments.map { $0.clienteUid })
        fetchUserInfo(uids: clientUids, userType: "client")
    }
    
    private func fetchUserInfo(uids: Set<String>, userType: String) {
        let group = DispatchGroup()
        
        for uid in uids {
            group.enter()
            guard let url = URL(string: "http://localhost:3000/getUser?uid=\(uid)") else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                defer { group.leave() }
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received for user: \(uid)")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                    
                    if userType == "attorney" {
                        let attorney = try decoder.decode(AttorneyBasic.self, from: data)
                        DispatchQueue.main.async {
                            self.attorneys[uid] = attorney
                        }
                    } else {
                        let user = try decoder.decode(UserBasic.self, from: data)
                        DispatchQueue.main.async {
                            self.clients[uid] = user
                        }
                    }
                } catch {
                    print("Error decoding user data for \(uid): \(error)")
                }
            }.resume()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
}

struct AppointmentsView: View {
    @StateObject private var viewModel = AppointmentViewModel()
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        currentAppointments
                        previousAppointments
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color("btBackground"))
        .navigationTitle("Citas")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchAppointments(userId: authModel.userData.uid, userType: authModel.userData.tipo)
        }
    }
    
    private var currentAppointments: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cita proxima")
                .font(.system(size: 18))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            ForEach(viewModel.appointments.filter { $0.estado == "pendiente" }) { appointment in
                if authModel.userData.tipo == "cliente" {
                    CurrentAppointmentsCard(
                        appointment: appointment,
                        attorney: viewModel.attorneys[appointment.abogadoUid],
                        userType: authModel.userData.tipo
                    )
                    .padding(.horizontal, 10)
                } else {
                    CurrentAppointmentsCard(
                        appointment: appointment,
                        client: viewModel.clients[appointment.clienteUid],
                        userType: authModel.userData.tipo
                    )
                    .padding(.horizontal, 10)
                }
            }
        }
    }
    
    private var previousAppointments: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Citas previas")
                .font(.system(size: 18))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            
            let previousAppointments = viewModel.appointments.filter { $0.estado != "pendiente" }
            
            if previousAppointments.isEmpty {
                noPreviousAppointmentsView
            } else {
                ForEach(previousAppointments) { appointment in
                    if authModel.userData.tipo == "cliente" {
                        PreviousAppointmentsCard(
                            appointment: appointment,
                            attorney: viewModel.attorneys[appointment.abogadoUid],
                            userType: authModel.userData.tipo
                        )
                        .padding(.horizontal, 10)
                    } else {
                        PreviousAppointmentsCard(
                            appointment: appointment,
                            client: viewModel.clients[appointment.clienteUid],
                            userType: authModel.userData.tipo
                        )
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
    
    private var noPreviousAppointmentsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(Color("btBlue"))
            
            Text("No hay citas previas")
                .font(CustomFonts.PoppinsBold(size: 16))
                .foregroundColor(Color.primary)
            
            Text("Cuando tengas citas completadas o canceladas, aparecerán aquí.")
                .font(CustomFonts.MontserratMedium(size: 14))
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("btBlue"), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 10)
    }
}

struct CurrentAppointmentsCard: View {
    let appointment: Appointment
    let attorney: AttorneyBasic?
    let client: UserBasic?
    let userType: String
    
    init(appointment: Appointment, attorney: AttorneyBasic? = nil, client: UserBasic? = nil, userType: String) {
        self.appointment = appointment
        self.attorney = attorney
        self.client = client
        self.userType = userType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            userInfo
            reasonInfo
            dateTime
        }
        .padding(20)
        .background(Color("btBlue"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(userType == "cliente" ? attorney?.nombre ?? "Cita Programada" : client?.nombre ?? "Cita Programada")
                    .font(CustomFonts.PoppinsBold(size: 18))
                    .foregroundColor(Color.white)
                
                Text(appointment.estado.capitalized)
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
    }
    
    private var userInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            if userType == "cliente" {
                Text(attorney?.email ?? "")
                    .font(CustomFonts.MontserratMedium(size: 14))
                    .foregroundColor(Color.white)
                
                Text("Teléfono: \(attorney?.celular ?? "")")
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.white.opacity(0.8))
            } else {
                Text(client?.email ?? "")
                    .font(CustomFonts.MontserratMedium(size: 14))
                    .foregroundColor(Color.white)
                
                Text("Teléfono: \(client?.celular ?? "")")
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.white.opacity(0.8))
            }
        }
    }
    
    private var reasonInfo: some View {
        HStack(spacing: 5) {
            Text("Notas: ")
                .font(CustomFonts.MontserratMedium(size: 12))
                .fontWeight(.black)
            Text(appointment.notas ?? "Sin notas")
                .font(CustomFonts.MontserratMedium(size: 12))
        }
        .foregroundColor(Color.white)
    }
    
    private var dateTime: some View {
        HStack {
            Spacer()
            Image(systemName: "calendar")
            Text(formattedDate)
                .font(CustomFonts.MontserratMedium(size: 12))
            Spacer()
            Image(systemName: "clock")
            Text(formattedTime)
                .font(CustomFonts.MontserratMedium(size: 12))
            Spacer()
        }
        .foregroundStyle(Color("btBlue"))
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(10)
        .padding(.top, 10)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy"
        return formatter.string(from: appointment.fechaHora)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: appointment.fechaHora)
    }
}

struct PreviousAppointmentsCard: View {
    let appointment: Appointment
    let attorney: AttorneyBasic?
    let client: UserBasic?
    let userType: String
    
    init(appointment: Appointment, attorney: AttorneyBasic? = nil, client: UserBasic? = nil, userType: String) {
        self.appointment = appointment
        self.attorney = attorney
        self.client = client
        self.userType = userType
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                header
                userInfo
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                dateInfo
                timeInfo
            }
        }
        .padding(20)
        .background(Color.clear)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text(userType == "cliente" ? attorney?.nombre ?? "Cita Previa" : client?.nombre ?? "Cita Previa")
                .font(CustomFonts.PoppinsBold(size: 18))
                .foregroundColor(Color.primary)
            
            Text(appointment.estado.capitalized)
                .font(CustomFonts.MontserratMedium(size: 12))
                .foregroundColor(Color.secondary)
        }
    }
    
    private var userInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            if userType == "cliente" {
                Text(attorney?.email ?? "")
                    .font(CustomFonts.MontserratMedium(size: 14))
                    .foregroundColor(Color.primary)
                
                Text("Teléfono: \(attorney?.celular ?? "")")
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.secondary)
            } else {
                Text(client?.email ?? "")
                    .font(CustomFonts.MontserratMedium(size: 14))
                    .foregroundColor(Color.primary)
                
                Text("Teléfono: \(client?.celular ?? "")")
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.secondary)
            }
        }
    }
        
    private var dateInfo: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(Color("btBlue"))
            Text(formattedDate)
                .font(CustomFonts.MontserratMedium(size: 12))
                .foregroundColor(Color.primary)
        }
    }
    
    private var timeInfo: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundColor(Color("btBlue"))
            Text(formattedTime)
                .font(CustomFonts.MontserratMedium(size: 12))
                .foregroundColor(Color.primary)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy"
        return formatter.string(from: appointment.fechaHora)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: appointment.fechaHora)
    }
}

#Preview {
    AppointmentsView()
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
}
