import SwiftUI

struct CalendarDay: Identifiable {
    let date: Date
    let id: UUID
}

struct CreateAppointmentView: View {
    let attorney: Attorney
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authModel: AuthModel
    @StateObject private var viewModel = CreateAppointmentViewModel()
    @Binding var isPresented: Bool
    
    @State private var selectedDate = Date()
    @State private var selectedTime: String? = nil
    @State private var currentMonthOffset: Int = 0
    @State private var appointmentReason: String = ""
    
    @State private var showingConfirmationAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AppointmentCardInfo(
                    name: attorney.nombre,
                    specialty: attorney.especialidad,
                    phoneNumber: attorney.celular,
                    email: attorney.email,
                    address: "N/A"
                )
                .padding(.horizontal, 10)
                
                calendarSection
                timeSelectionSection
                reasonSection
                confirmButton
            }
            .padding(.bottom, 40)
        }
        .background(Color("btBackground"))
        .onTapGesture {
            self.hideKeyboard()
        }
        .navigationTitle("Agendar Cita")
        .alert(isPresented: $showingErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        .sheet(isPresented: $showingConfirmationAlert) {
            ConfirmationAlertView(
                name: attorney.nombre,
                selectedDate: selectedDate,
                selectedTime: selectedTime ?? "",
                dismiss: {
                    showingConfirmationAlert = false
                    isPresented = false
                }
            )
        }
        .onAppear {
            viewModel.fetchAvailability(for: attorney, month: selectedDate)
            viewModel.handleDateChange(for: selectedDate)
        }
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Selecciona una fecha")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("btBlue"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            CustomCalendarView(
                selectedDate: $selectedDate,
                availability: viewModel.availability,
                currentMonthOffset: $currentMonthOffset,
                onDateChange: handleDateChange,
                onMonthChange: { date in
                    viewModel.fetchAvailability(for: attorney, month: date)
                }
            )
            .padding(.horizontal, 20)
        }
    }
    
    private var timeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Selecciona un horario")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("btBlue"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.isDateAvailable {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(viewModel.availableTimes, id: \.self) { time in
                        Button(action: {
                            selectedTime = (selectedTime == time) ? nil : time
                        }) {
                            Text(time)
                                .font(CustomFonts.PoppinsSemiBold(size: 16))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTime == time ? Color("btBlue") : (colorScheme == .light ? Color.white : Color.clear))
                                .foregroundColor(selectedTime == time ? Color.white : Color("btBlue"))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("btBlue"), lineWidth: 1)
                                )
                        }
                    }
                }
            } else {
                Text("No hay horarios disponibles para este día.")
                    .font(CustomFonts.MontserratRegular(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var reasonSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Motivo de la cita")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("btBlue"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $appointmentReason)
                    .frame(height: 100)
                    .padding(10)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("btBlue"), lineWidth: 1)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(colorScheme == .light ? Color.white : Color.black))
                    )
                
                if appointmentReason.isEmpty {
                    Text("Escribe aquí el motivo de la cita")
                        .foregroundColor(Color.gray.opacity(0.7))
                        .padding(15)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var confirmButton: some View {
        Button(action: createAppointment) {
            Text("Continuar")
                .font(CustomFonts.PoppinsSemiBold(size: 18))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isFormValid ? Color("btBlue") : Color.gray.opacity(0.6))
                .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .disabled(!isFormValid)
    }
    
    private var isFormValid: Bool {
        viewModel.isDateAvailable && selectedTime != nil && !appointmentReason.isEmpty
    }
    
    private func handleDateChange(for date: Date) {
        viewModel.handleDateChange(for: date)
        selectedTime = nil
    }
    
    private func createAppointment() {
        guard let selectedTime = selectedTime else {
            errorMessage = "Por favor selecciona una hora para la cita."
            showingErrorAlert = true
            return
        }
        
        viewModel.createAppointment(
            abogadoUid: attorney.uid,
            clienteUid: authModel.userData.uid,
            fecha: selectedDate,
            hora: selectedTime,
            motivo: appointmentReason
        ) { result in
            switch result {
            case .success:
                showingConfirmationAlert = true
            case .failure(let error):
                errorMessage = "Error al crear la cita: \(error.localizedDescription)"
                showingErrorAlert = true
            }
        }
    }
}

struct AppointmentCardInfo: View {
    @Environment(\.colorScheme) var colorScheme
    let name: String
    let specialty: String
    let phoneNumber: String
    let email: String
    let address: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            contactInfo
        }
        .padding()
        .background(colorScheme == .dark ? .gray.opacity(0.15) : .white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("btBlue"), lineWidth: 1)
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(CustomFonts.PoppinsBold(size: 20))
                    .foregroundColor(Color("btBlue"))
                
                Text(specialty)
                    .font(CustomFonts.MontserratMedium(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color("btBlue"))
                .offset(y: 3)
        }
    }
    
    private var contactInfo: some View {
        HStack(spacing: 10) {
            contactInfoItem(icon: "phone.fill", text: phoneNumber)
            contactInfoItem(icon: "envelope.fill", text: email)
        }
    }
    
    private func contactInfoItem(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
            Text(text)
        }
        .font(CustomFonts.MontserratBold(size: 12))
        .foregroundColor(Color("btBlue"))
    }
    
    private var addressInfo: some View {
        HStack(spacing: 5) {
            Image(systemName: "mappin.and.ellipse")
            Text(address)
                .font(CustomFonts.MontserratMedium(size: 12))
        }
        .foregroundColor(Color("btBlue"))
    }
}

struct ConfirmationAlertView: View {
    @Environment(\.colorScheme) var colorScheme
    let name: String
    let selectedDate: Date
    let selectedTime: String
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
            
            Text("Cita Confirmada")
                .font(CustomFonts.PoppinsBold(size: 20))
                .foregroundColor(.primary)
            
            Text("Tu cita con \(name) ha sido confirmada")
                .font(CustomFonts.MontserratRegular(size: 14))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            HStack {
                HStack {
                    Image(systemName: "calendar")
                    Text("\(selectedDate, style: .date)")
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text(selectedTime)
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(.primary)
                }
            }
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("C. Av. Luis Elizondo y Garza Sada, Tecnológico, 64700 Monterrey, N.L.")
                    .font(CustomFonts.MontserratRegular(size: 12))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 10)
            
            Button(action: dismiss) {
                Text("Continuar")
                    .font(CustomFonts.PoppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("btBlue"))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color("btBackground"))
        .cornerRadius(20)
    }
}

// Uncomment this for previews
// #Preview {
//     CreateAppointmentView(attorney: Attorney.sampleData)
//         .environmentObject(AuthModel())
// }
