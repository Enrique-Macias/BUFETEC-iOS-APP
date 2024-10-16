import SwiftUI
import Foundation

struct Appointment: Identifiable, Codable {
    let id: String
    let abogadoUid: String
    let clienteUid: String
    let fechaHora: Date
    let estado: String
    let motivo: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case abogadoUid, clienteUid, fechaHora, estado, motivo
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

struct AppointmentsListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AppointmentViewModel
    @EnvironmentObject var authModel: AuthModel
    @State private var showAttorneysList = false
    
    var body: some View {
        ZStack {
            ScrollView {
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
                .padding(.bottom, 80)
            }
            .background(Color("btBackground"))
            .navigationTitle("Citas")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchAppointments()
            }
            
            if authModel.userData.tipo == "cliente" {
                VStack {
                    Spacer()
                    Button(action: {
                        showAttorneysList = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.accentColor)
                            .background(Color("btBackground"))
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showAttorneysList, onDismiss: {
            fetchAppointments()
        }) {
            AttorneysListView(isPresented: $showAttorneysList)
        }
    }
    
    private func fetchAppointments() {
        viewModel.fetchAppointments(userId: authModel.userData.uid, userType: authModel.userData.tipo)
    }
    
    private var currentAppointments: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Citas próximas")
                .font(.system(size: 18))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.leading, 3)

            // Ordenar las citas actuales por fecha y hora
            let currentAppointments = viewModel.appointments
                .filter { $0.estado != "completada" && $0.estado != "cancelada" }
                .sorted { $0.fechaHora < $1.fechaHora }

            if currentAppointments.isEmpty {
                noNextAppointmentView
            } else {
                ForEach(currentAppointments) { appointment in
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
    }

    private var previousAppointments: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Citas previas")
                .font(.system(size: 18))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.leading, 3)

            // Ordenar las citas previas por fecha y hora
            let previousAppointments = viewModel.appointments
                .filter { $0.estado == "completada" || $0.estado == "cancelada" }
                .sorted { $0.fechaHora < $1.fechaHora }

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

    
    private var noNextAppointmentView: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(Color.accentColor)
            
            Text("No hay citas proximas")
                .font(CustomFonts.PoppinsBold(size: 16))
                .foregroundColor(Color.primary)
            
            Text("Cuando tengas citas agendadas, apareceran aqui.")
                .font(CustomFonts.MontserratMedium(size: 14))
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.15))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 10)
    }
    
    private var noPreviousAppointmentsView: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(Color.accentColor)
            
            Text("No hay citas previas")
                .font(CustomFonts.PoppinsBold(size: 16))
                .foregroundColor(Color.primary)
            
            Text("Cuando tengas citas completadas o canceladas, aparecerán aquí.")
                .font(CustomFonts.MontserratMedium(size: 14))
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.15))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 10)
    }
}

import SwiftUI

struct CurrentAppointmentsCard: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AppointmentViewModel
    @EnvironmentObject var authModel: AuthModel
    @State private var showCancelConfirmation = false
    @State private var showCompleteConfirmation = false
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
        .background(colorScheme == .light ? Color.accentColor : Color.gray.opacity(0.15))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .alert(isPresented: $showCancelConfirmation) {
            Alert(
                title: Text("Confirmar Cancelación"),
                message: Text("¿Estás seguro de que quieres cancelar esta cita?"),
                primaryButton: .destructive(Text("Cancelar Cita")) {
                    cancelAppointment()
                },
                secondaryButton: .cancel()
            )
        }
        .alert("Confirmar Completar", isPresented: $showCompleteConfirmation) {
            Button("Completar", role: .destructive) {
                updateAppointmentStatus(to: "completada")
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("¿Estás seguro de que quieres marcar esta cita como completada?")
        }
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(userType == "cliente" ? attorney?.nombre ?? "Cita Programada" : client?.nombre ?? "Cita Programada")
                    .font(CustomFonts.PoppinsBold(size: 18))
                    .foregroundColor(Color.white)
                
                statusView
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.white)
                .offset(y: 3)
        }
    }
    
    private var statusView: some View {
        Group {
            if userType == "abogado" {
                Menu {
                    ForEach(["pendiente", "confirmada", "cancelada", "completada"], id: \.self) { status in
                        Button(action: {
                            if status == "cancelada" {
                                showCancelConfirmation = true
                            } else if status == "completada" {
                                showCompleteConfirmation = true
                            } else {
                                updateAppointmentStatus(to: status)
                            }
                        }) {
                            Text(status.capitalized)
                        }
                    }
                } label: {
                    HStack {
                        Text(appointment.estado.capitalized)
                            .font(CustomFonts.MontserratMedium(size: 12))
                            .foregroundColor(Color.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(Color.white)
                    }
                }
            } else {
                Text(appointment.estado.capitalized)
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.white)
            }
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
            Text("Motivo: ")
                .font(CustomFonts.MontserratMedium(size: 12))
                .fontWeight(.black)
            Text(appointment.motivo ?? "Motivo no definido.")
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
        .foregroundStyle(colorScheme == .light ? Color.accentColor : Color.primary)
        .padding(.vertical, 10)
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.15))
        .frame(maxWidth: .infinity)
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
    
    private func updateAppointmentStatus(to status: String) {
        viewModel.updateAppointmentStatus(
            appointmentId: appointment.id,
            newStatus: status,
            userId: authModel.userData.uid,
            userType: authModel.userData.tipo
        ) { success in
            if !success {
                print("Failed to update appointment status")
            }
        }
    }
    
    private func cancelAppointment() {
        viewModel.cancelAppointment(
            appointmentId: appointment.id,
            userId: authModel.userData.uid,
            userType: authModel.userData.tipo
        ) { success in
            if !success {
                print("Failed to cancel appointment")
            }
        }
    }
}

struct PreviousAppointmentsCard: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AppointmentViewModel
    @EnvironmentObject var authModel: AuthModel
    @State private var showDeleteConfirmation = false
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
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.15))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Confirmar Eliminación"),
                message: Text("¿Estás seguro de que quieres eliminar esta cita?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    deleteAppointment()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text(userType == "cliente" ? attorney?.nombre ?? "Cita Previa" : client?.nombre ?? "Cita Previa")
                .font(CustomFonts.PoppinsBold(size: 18))
                .foregroundColor(Color.primary)
            
            statusView
        }
    }
    
    private var statusView: some View {
        Group {
            if userType == "abogado" && (appointment.estado == "cancelada" || appointment.estado == "completada") {
                HStack {
                    Text(appointment.estado.capitalized)
                        .font(CustomFonts.MontserratMedium(size: 12))
                        .foregroundColor(Color.secondary)
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color.accentColor)
                    }
                }
            } else {
                Text(appointment.estado.capitalized)
                    .font(CustomFonts.MontserratMedium(size: 12))
                    .foregroundColor(Color.secondary)
            }
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
                .foregroundStyle(colorScheme == .light ? Color.accentColor : Color.primary)
            Text(formattedDate)
                .font(CustomFonts.MontserratMedium(size: 12))
                .foregroundColor(Color.primary)
        }
    }
    
    private var timeInfo: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundStyle(colorScheme == .light ? Color.accentColor : Color.primary)
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
    
    private func deleteAppointment() {
        viewModel.deleteAppointment(
            appointmentId: appointment.id,
            userId: authModel.userData.uid,
            userType: authModel.userData.tipo
        ) { success in
            if !success {
                print("Failed to delete appointment")
            }
        }
    }
}

#Preview {
    AppointmentsListView()
        .environmentObject(AuthModel())
        .environmentObject(AppointmentViewModel())
}
