import SwiftUI

struct AppointmentScheduleView: View {
    // MARK: - Properties
    @State private var selectedTab: String = "Dias"
    @State private var horarioSemanal: [String: [Date]] = [:]
    @State private var selectedDay: String = ""
    @State private var showingTimePicker = false
    @State private var newHorario = Date()
    @State private var showGuardarCambios = false
    @State private var showSuccessAlert = false
    @State private var shouldHideGuardarCambios = false
    
    @State private var selectedCalendarDate = Date()
    @State private var customHorarios: [Date: [Date]] = [:]
    @State private var excepcionesFechas: [ExcepcionFecha] = []
    @State private var removedHorarios: [Date: [Date]] = [:]
    
    private let daysOfWeek = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
    private let dayAbbreviations = ["lun", "mar", "mie", "jue", "vie", "sab", "dom"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                        .padding(.bottom, 20)
                    tabSelectionSection
                        .padding(.bottom, 10)

                    
                    if selectedTab == "Dias" {
                        diasView
                    } else if selectedTab == "Calendario" {
                        calendarioView
                    }
                    
                    if showingTimePicker {
                        timePickerModal
                    }
                }
                                
                guardarCambiosButton
                
                if showSuccessAlert {
                    successAlertView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Text("Definir Horarios")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("btBlue"))
                .padding(.bottom, 5)
                .padding(.leading, 20)
            
            Text("Define tu horario semanal y remueve las fechas que no deseas en la vista de calendario.")
                .font(CustomFonts.MontserratRegular(size: 14))
                .foregroundColor(Color.primary)
                .lineSpacing(5)
                .padding(.leading, 20)
        }
    }
    
    private var tabSelectionSection: some View {
        HStack(spacing: 10) {
            tabButton(title: "Días de la Semana", tab: "Dias")
            tabButton(title: "Calendario", tab: "Calendario")
        }
        .padding(.horizontal, 20)
    }
    
    private func tabButton(title: String, tab: String) -> some View {
        Button(action: {
            selectedTab = tab
            if tab == "Calendario" {
                syncHorariosWithCalendar()
            }
        }) {
            Text(title)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(selectedTab == tab ? Color.white : Color("btBlue"))
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedTab == tab ? Color("btBlue") : Color.white)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("btBlue"), lineWidth: 2))
                .cornerRadius(10)
        }
    }
    
    private var diasView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(daysOfWeek, id: \.self) { day in
                    daySection(day: day)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .padding(.bottom, 90)
        }
    }
    
    private func daySection(day: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(day)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(Color("btBlue"))
                .padding(.leading, 20)
            
            if let horariosDelDia = horarioSemanal[day] {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                    ForEach(horariosDelDia, id: \.self) { horario in
                        horarioItem(day: day, horario: horario)
                    }
                }
                .padding(.leading, 10)
            }
            
            addHorarioButton(for: day)
        }
    }
    
    private func horarioItem(day: String, horario: Date) -> some View {
        HStack {
            Text(formattedTime(for: horario))
                .font(.system(size: 16))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
                .frame(width: 78)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("btBlue"), lineWidth: 2))
                .cornerRadius(8)
            
            Button(action: {
                deleteHorario(day: day, horario: horario)
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color("btBlue"))
                    .padding(.trailing, 5)
            }
        }
    }
    
    private func addHorarioButton(for day: String) -> some View {
        Button(action: {
            selectedDay = day
            showingTimePicker = true
        }) {
            Text("Agregar Horario")
                .font(CustomFonts.PoppinsSemiBold(size: 14))
                .foregroundColor(Color.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color("btBlue"))
                .cornerRadius(8)
                .padding(.leading, 20)
        }
    }
    
    private var calendarioView: some View {
        ScrollView {
            VStack {
                DatePicker("Seleccionar fecha", selection: $selectedCalendarDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .onChange(of: selectedCalendarDate) { oldDate, newDate in
                        syncHorariosForSelectedDate(newDate)
                    }
                
                if let horariosFecha = getHorariosForDate(selectedCalendarDate) {
                    Text("Horarios:")
                        .font(CustomFonts.PoppinsSemiBold(size: 16))
                        .foregroundColor(Color("btBlue"))
                        .padding(.leading, 20)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(horariosFecha, id: \.self) { horario in
                            calendarHorarioItem(horario: horario)
                        }
                    }
                    .padding(.leading, 20)
                }
            }
        }
    }
    
    private func calendarHorarioItem(horario: Date) -> some View {
        HStack {
            Text(formattedTime(for: horario))
                .font(CustomFonts.PoppinsMedium(size: 10))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("btBlue"), lineWidth: 2))
                .cornerRadius(8)
            
            Button(action: {
                deleteHorarioFromCalendar(date: selectedCalendarDate, horario: horario)
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color("btBlue"))
                    .padding(.trailing, 10)
            }
        }
    }
    
    private var timePickerModal: some View {
        VStack {
            DatePicker("Seleccionar Hora", selection: $newHorario, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
            
            Button("Agregar") {
                let calendar = Calendar.current
                let newHourMinute = calendar.dateComponents([.hour, .minute], from: newHorario)
                
                if selectedTab == "Calendario" {
                    if customHorarios[selectedCalendarDate] == nil {
                        customHorarios[selectedCalendarDate] = []
                    }
                    if !customHorarios[selectedCalendarDate]!.contains(where: { calendar.dateComponents([.hour, .minute], from: $0) == newHourMinute }) {
                        customHorarios[selectedCalendarDate]?.append(newHorario)
                        showGuardarCambios = true
                        shouldHideGuardarCambios = false
                    }
                } else if selectedTab == "Dias" {
                    if horarioSemanal[selectedDay] == nil {
                        horarioSemanal[selectedDay] = []
                    }
                    if !horarioSemanal[selectedDay]!.contains(where: { calendar.dateComponents([.hour, .minute], from: $0) == newHourMinute }) {
                        horarioSemanal[selectedDay]?.append(newHorario)
                        showGuardarCambios = true
                        shouldHideGuardarCambios = false
                    }
                }
                showingTimePicker = false
            }
            .padding()
            .background(Color("btBlue"))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    private var guardarCambiosButton: some View {
        VStack {
            Spacer()
            if showGuardarCambios && !shouldHideGuardarCambios {
                Button(action: {
                    guardarCambios()
                }) {
                    Text("Guardar Cambios")
                        .font(CustomFonts.PoppinsSemiBold(size: 16))
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("btBlue"))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
    }
    
    private var successAlertView: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 40))
                Text("Cambios guardados con éxito")
                    .font(CustomFonts.PoppinsSemiBold(size: 16))
                    .foregroundColor(.green)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Helper Functions
    private func syncHorariosWithCalendar() {
        let calendar = Calendar.current
        customHorarios.removeAll()
        
        for day in horarioSemanal.keys {
            if let dayIndex = daysOfWeek.firstIndex(of: day) {
                let currentDate = calendar.date(bySetting: .weekday, value: (dayIndex + 1) % 7 + 1, of: selectedCalendarDate)
                if let date = currentDate {
                    customHorarios[date] = horarioSemanal[day]
                }
            }
        }
    }
    
    private func syncHorariosForSelectedDate(_ date: Date) {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let dayName = daysOfWeek[(dayOfWeek + 5) % 7]
        customHorarios[date] = horarioSemanal[dayName]
    }
    
    private func getHorariosForDate(_ date: Date) -> [Date]? {
        let baseHorarios = customHorarios[date] ?? []
        let removedHorariosForDate = removedHorarios[date] ?? []
        return baseHorarios.filter { !removedHorariosForDate.contains($0) }
    }
    
    private func deleteHorario(day: String, horario: Date) {
        horarioSemanal[day]?.removeAll { $0 == horario }
        if horarioSemanal[day]?.isEmpty ?? true {
            horarioSemanal.removeValue(forKey: day)
        }
        
        // Remove this horario from all dates in customHorarios
        for (date, horarios) in customHorarios {
            customHorarios[date] = horarios.filter { $0 != horario }
        }
        
        // Remove from removedHorarios if it exists
        for (date, _) in removedHorarios {
            removedHorarios[date]?.removeAll { $0 == horario }
            if removedHorarios[date]?.isEmpty ?? true {
                removedHorarios.removeValue(forKey: date)
            }
        }
        
        showGuardarCambios = true
    }
    
    private func deleteHorarioFromCalendar(date: Date, horario: Date) {
        if removedHorarios[date] == nil {
            removedHorarios[date] = []
        }
        removedHorarios[date]?.append(horario)
        
        // Add to excepcionesFechas
        let excepcion = ExcepcionFecha(fechaHora: combineDateAndTime(date: date, time: horario), razon: "Cita programada")
        excepcionesFechas.append(excepcion)
        
        showGuardarCambios = true
    }
    
    private func guardarCambios() {
        // Convert horarioSemanal to the required format
        var horarioSemanalFormatted: [String: [String]] = [:]
        for (day, horarios) in horarioSemanal {
            if let index = daysOfWeek.firstIndex(of: day) {
                let dayAbbr = dayAbbreviations[index]
                horarioSemanalFormatted[dayAbbr] = horarios.map { formattedTime(for: $0) }
            }
        }
        
        // Convert excepcionesFechas to the required format
        let excepcionesFormatted = excepcionesFechas.map { excepcion -> [String: String] in
            let dateFormatter = ISO8601DateFormatter()
            return [
                "fechaHora": dateFormatter.string(from: excepcion.fechaHora),
                "razon": excepcion.razon
            ]
        }
        
        // Print to console
        print("\"horarioSemanal\": \(horarioSemanalFormatted)")
        print("\"excepcionesFechas\": \(excepcionesFormatted)")
        
        // Show alert
        showSuccessAlert = true
        shouldHideGuardarCambios = true
        
        // Hide the alert after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSuccessAlert = false
        }
    }
    
    private func formattedTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        return calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)) ?? date
    }
}

struct ExcepcionFecha: Identifiable {
    let id = UUID()
    let fechaHora: Date
    let razon: String
}

#Preview {
    AppointmentScheduleView()
}
