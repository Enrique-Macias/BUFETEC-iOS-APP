import SwiftUI

struct CreateAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate = Date()
    @State private var selectedTime: String? = nil
    @State private var availableTimes: [String] = []
    @State private var isDateAvailable: Bool = true
    @State private var currentMonthOffset: Int = 0
    
    @State private var showingConfirmationAlert = false
    @State private var showingErrorAlert = false
    
    // Disponibilidad de fechas (más de 4 verde, entre 1 y 4 amarillo, 0 rojo)
    let availability: [Date: Int] = [
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 25))!: 5, // Verde
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 26))!: 2, // Amarillo
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 27))!: 3, // Amarillo
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 28))!: 0, // Rojo
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 29))!: 6, // Verde
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 1))!: 0, // Rojo
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 2))!: 4, // Amarillo
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 3))!: 1, // Amarillo
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 4))!: 0, // Rojo
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5))!: 5  // Verde
    ]
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Usar AppointmentCardInfo
                    AppointmentCardInfo(
                        name: "Bruno García",
                        specialty: "Abogado Familiar",
                        phoneNumber: "81 1234 5678",
                        email: "bruno@bufetec.mx",
                        address: "C. Av. Luis Elizondo y Garza Sada,\nTecnológico, 64700 Monterrey, N.L."
                    )
                    .padding(.horizontal, 10)
                    
                    // Sección de seleccionar fecha
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Selecciona una fecha")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color("btBlue"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        // Calendario personalizado
                        CustomCalendarView(
                            selectedDate: $selectedDate,
                            availability: availability,
                            currentMonthOffset: $currentMonthOffset,
                            onDateChange: handleDateChange(for:)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // Sección de seleccionar hora o mensaje de no disponibilidad
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Selecciona un horario")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color("btBlue"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if isDateAvailable {
                            // Grid de horas disponibles
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                                ForEach(availableTimes, id: \.self) { time in
                                    Button(action: {
                                        if selectedTime == time {
                                            selectedTime = nil // Deseleccionar si ya está seleccionada
                                        } else {
                                            selectedTime = time
                                        }
                                    }) {
                                        Text(time)
                                            .font(CustomFonts.PoppinsSemiBold(size: 16))
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(selectedTime == time ? Color("btBlue") : Color.white)
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
                            // Mensaje de no disponibilidad
                            Text("No hay horarios disponibles para este día.")
                                .font(CustomFonts.MontserratRegular(size: 16))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Botón de confirmar cita (deshabilitado si no hay citas disponibles)
                    Button(action: {
                        if selectedTime != nil {
                            showingConfirmationAlert = true
                        } else {
                            showingErrorAlert = true
                        }
                    }) {
                        Text("Confirmar cita")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isDateAvailable && selectedTime != nil ? Color("btBlue") : Color.gray.opacity(0.6))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .disabled(!isDateAvailable || selectedTime == nil)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Agendar Cita")
            .alert(isPresented: $showingErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Por favor selecciona una hora para la cita."),
                    dismissButton: .default(Text("Aceptar"))
                )
            }
            .sheet(isPresented: $showingConfirmationAlert) {
                ConfirmationAlertView(selectedDate: selectedDate, selectedTime: selectedTime ?? "", dismiss: { showingConfirmationAlert = false })
            }
        }
    }
    
    // Manejar el cambio de fecha seleccionada
    private func handleDateChange(for date: Date) {
        let calendar = Calendar.current
        if let availabilityForDate = availability[calendar.startOfDay(for: date)] {
            if availabilityForDate > 0 {
                isDateAvailable = true
                // Configura horarios disponibles según la disponibilidad
                if availabilityForDate > 4 {
                    availableTimes = ["9:00 am", "10:00 am", "11:00 am", "1:00 pm", "2:00 pm", "3:00 pm"]
                } else {
                    availableTimes = ["10:00 am", "1:00 pm"] // Ejemplo de pocos horarios
                }
            } else {
                isDateAvailable = false
            }
        } else {
            isDateAvailable = false
        }
    }
}

struct ConfirmationAlertView: View {
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
            
            Text("Tu cita con Bruno García ha sido confirmada")
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
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    var availability: [Date: Int]
    @Binding var currentMonthOffset: Int
    var onDateChange: (Date) -> Void
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private let daysOfWeek = ["L", "M", "X", "J", "V", "S", "D"]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentMonthOffset -= 1
                    selectedDate = getCurrentMonthDate()
                    onDateChange(selectedDate)
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text("\(getMonthAndYear())")
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                Button(action: {
                    currentMonthOffset += 1
                    selectedDate = getCurrentMonthDate()
                    onDateChange(selectedDate)
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            HStack(spacing: 15) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)
            
            let days = createDaysForMonth(for: selectedDate)
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(days, id: \.self) { day in
                    VStack {
                        Text("\(calendar.component(.day, from: day))")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isPastDate(day) ? Color.gray.opacity(0.5) : (calendar.isDate(selectedDate, inSameDayAs: day) ? Color.white : Color.black))
                            .frame(width: 32, height: 32)
                            .background(isPastDate(day) ? Color.clear : (calendar.isDate(selectedDate, inSameDayAs: day) ? Color("btBlue") : Color.clear))
                            .cornerRadius(16)
                            .onTapGesture {
                                if !isPastDate(day) {
                                    selectedDate = day
                                    onDateChange(day)
                                }
                            }
                        
                        if !isPastDate(day) {
                            if let availabilityCount = availability[calendar.startOfDay(for: day)] {
                                Circle()
                                    .fill(getAvailabilityColor(for: availabilityCount))
                                    .frame(width: 8, height: 8)
                            } else {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getCurrentMonthDate() -> Date {
        let today = Date()
        return calendar.date(byAdding: .month, value: currentMonthOffset, to: today)!
    }
    
    private func createDaysForMonth(for date: Date) -> [Date] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        let firstDayOfMonth = calendar.component(.weekday, from: startDate)
        let leadingEmptyDays = firstDayOfMonth == 1 ? 6 : firstDayOfMonth - 2
        
        let days = (1...range.count).compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
        
        let emptyDays = Array(repeating: Date.distantPast, count: leadingEmptyDays)
        return emptyDays + days
    }
    
    private func getMonthAndYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: getCurrentMonthDate())
    }
    
    
    // Definir el color de los puntos según la disponibilidad
    private func getAvailabilityColor(for count: Int) -> Color {
        switch count {
        case 5...:
            return .green
        case 1...4:
            return .yellow
        default:
            return .red
        }
    }
    
    // Comprobar si una fecha es anterior al día actual
    private func isPastDate(_ date: Date) -> Bool {
        return calendar.compare(date, to: Date(), toGranularity: .day) == .orderedAscending
    }
}

// Componente para la tarjeta de información del abogado
struct AppointmentCardInfo: View {
    let name: String
    let specialty: String
    let phoneNumber: String
    let email: String
    let address: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            contactInfo
            addressInfo
        }
        .padding()
        .background(Color.white)
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

#Preview {
    CreateAppointmentView()
        .environment(AppearanceManager())
}

