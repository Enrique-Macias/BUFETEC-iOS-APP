import SwiftUI

struct AppointmentScheduleView: View {
    @EnvironmentObject var authModel: AuthModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedTab: String = "Dias"
    @State private var horarioSemanal: [String: [Date]] = [:]
    @State private var selectedDay: String = ""
    @State private var showingTimePicker = false
    @State private var newHorario = Date()
    @State private var showGuardarCambios = false
    @State private var showSuccessAlert = false
    @State private var shouldHideGuardarCambios = false
    
    @State private var disabledHorarios: Set<Date> = []
    @State private var availability: [Date: [String]] = [:]
    
    @State private var selectedCalendarDate = Date()
    @State private var customHorarios: [Date: [Date]] = [:]
    @State private var excepcionesFechas: [ExcepcionFecha] = []
    @State private var removedHorarios: [Date: [Date]] = [:]
    
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    private let baseURL = APIURL.default
    
    private let daysOfWeek = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
    private let dayAbbreviations = ["lun", "mar", "mie", "jue", "vie", "sab", "dom"]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Cargando...")
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                    tabSelectionSection
                        .padding(.bottom, 10)
                    
                    if selectedTab == "Dias" {
                        diasView
                    } else if selectedTab == "Calendario" {
                        calendarioView
                    }
                }
                
                guardarCambiosButton
            }
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Confirmado"),
                message: Text("Se ha guardado el horario"),
                dismissButton: .default(Text("Aceptar")) {
                    dismiss()
                }
            )
        }
        .sheet(isPresented: $showingTimePicker) {
            timePickerModal
        }
//        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Definir horario")
        .onAppear {
            fetchAttorneyData()
        }
    }
    
    // MARK: - API Calls
    private let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(identifier: "America/Mexico_City")
        return formatter
    }()
    
    private func fetchAttorneyData() {
        let uid = authModel.userData.uid
        
        let urlString = "\(baseURL)/getAttorney?uid=\(uid)"
        guard let url = URL(string: urlString) else {
            errorMessage = "URL inválida"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error de red: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No se recibieron datos"
                    return
                }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Received JSON: \(jsonResult)")
                        
                        if let horarioSemanal = jsonResult["horarioSemanal"] as? [String: [String]] {
                            self.horarioSemanal = self.convertStringsToDates(horarioSemanal)
                        } else {
                            print("horarioSemanal is not in the expected format")
                        }
                        
                        if let excepcionesFechas = jsonResult["excepcionesFechas"] as? [[String: Any]] {
                            self.excepcionesFechas = excepcionesFechas.compactMap { excepcion in
                                guard let fechaHoraString = excepcion["fechaHora"] as? String,
                                      let fechaHora = self.iso8601Formatter.date(from: fechaHoraString),
                                      let razon = excepcion["razon"] as? String else {
                                    print("Failed to parse exception: \(excepcion)")
                                    return nil
                                }
                                return ExcepcionFecha(fechaHora: fechaHora, razon: razon)
                            }
                            
                            // Print the date and hour of each ExcepcionFecha
                            for excepcion in self.excepcionesFechas {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                dateFormatter.timeZone = TimeZone(identifier: "America/Mexico_City")
                                let dateString = dateFormatter.string(from: excepcion.fechaHora)
                                print("ExcepcionFecha: \(dateString)")
                            }
                        } else {
                            print("excepcionesFechas is not in the expected format")
                        }
                        
                        self.updateAvailability()
                        self.updateDisabledHorariosForSelectedDate()
                        self.isLoading = false
                    } else {
                        self.errorMessage = "Los datos no están en el formato JSON esperado"
                    }
                } catch {
                    self.errorMessage = "Error al procesar los datos: \(error.localizedDescription)"
                    print("Raw data received: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                }
            }
        }.resume()
    }
    
    
    private func updateAvailability() {
        let calendar = Calendar.current
        let currentDate = Date()
        let nextThreeMonths = calendar.date(byAdding: .month, value: 3, to: currentDate)!
        
        var tempAvailability: [Date: [String]] = [:]
        
        calendar.enumerateDates(startingAfter: currentDate, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else { return }
            if date > nextThreeMonths {
                stop = true
                return
            }
            
            let weekday = calendar.component(.weekday, from: date)
            let weekdayKey = dayAbbreviations[weekday - 1]
            
            if let availableHours = horarioSemanal[weekdayKey] {
                let startOfDay = calendar.startOfDay(for: date)
                let exceptionsForDay = excepcionesFechas.filter {
                    calendar.isDate($0.fechaHora, inSameDayAs: date)
                }
                
                var availableTimesForDay = availableHours.map { formattedTime(for: $0) }
                
                for exception in exceptionsForDay {
                    let exceptionTimeString = formattedTime(for: exception.fechaHora)
                    availableTimesForDay.removeAll { $0 == exceptionTimeString }
                }
                
                tempAvailability[startOfDay] = availableTimesForDay
            } else {
                tempAvailability[calendar.startOfDay(for: date)] = []
            }
        }
        
        self.availability = tempAvailability
    }
    
    private func updateAttorneyData() {
        let uid = authModel.userData.uid
        
        let url = URL(string: "\(baseURL)/updateAttorney")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let excepcionesFormatted = excepcionesFechas.map { excepcion -> [String: String] in
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "America/Mexico_City")
            return [
                "fechaHora": dateFormatter.string(from: excepcion.fechaHora),
                "razon": excepcion.razon
            ]
        }
        
        let body: [String: Any] = [
            "uid": uid,
            "horarioSemanal": convertDatesToStrings(horarioSemanal),
            "excepcionesFechas": excepcionesFormatted
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            errorMessage = "Error al preparar los datos: \(error.localizedDescription)"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.errorMessage = "Error del servidor"
                    return
                }
                
                self.showSuccessAlert = true
                self.shouldHideGuardarCambios = true
            }
        }.resume()
    }
    
    // MARK: - Helper Functions
    private func convertStringsToDates(_ horarioSemanal: [String: [String]]) -> [String: [Date]] {
        var convertedHorario: [String: [Date]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "America/Mexico_City")
        
        for (day, times) in horarioSemanal {
            convertedHorario[day] = times.compactMap { dateFormatter.date(from: $0) }
        }
        
        return convertedHorario
    }
    
    private func convertDatesToStrings(_ horarioSemanal: [String: [Date]]) -> [String: [String]] {
        var convertedHorario: [String: [String]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "America/Mexico_City")
        
        for (day, times) in horarioSemanal {
            convertedHorario[day] = times.map { dateFormatter.string(from: $0) }
        }
        
        return convertedHorario
    }
    
    private func deleteHorario(day: String, horario: Date) {
        let dayAbbr = dayAbbreviations[daysOfWeek.firstIndex(of: day)!]
        horarioSemanal[dayAbbr]?.removeAll { $0 == horario }
        if horarioSemanal[dayAbbr]?.isEmpty ?? true {
            horarioSemanal.removeValue(forKey: dayAbbr)
        }
        
        showGuardarCambios = true
    }
    
    private func deleteHorarioFromCalendar(date: Date, horario: Date) {
        if removedHorarios[date] == nil {
            removedHorarios[date] = []
        }
        removedHorarios[date]?.append(horario)
        
        let excepcion = ExcepcionFecha(fechaHora: combineDateAndTime(date: date, time: horario), razon: "Cita cancelada")
        excepcionesFechas.append(excepcion)
        
        showGuardarCambios = true
    }
    
    private func guardarCambios() {
        updateAttorneyData()
    }
    
    private func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        return calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)) ?? date
    }
    
    private func syncHorariosWithCalendar() {
        let calendar = Calendar.current
        customHorarios.removeAll()
        
        for day in horarioSemanal.keys {
            if let dayIndex = dayAbbreviations.firstIndex(of: day) {
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
        let dayName = dayAbbreviations[(dayOfWeek + 5) % 7]
        if customHorarios[date] == nil {
            customHorarios[date] = horarioSemanal[dayName]
        }
    }
    
    private func getHorariosForDate(_ date: Date) -> [Date]? {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let dayName = dayAbbreviations[(dayOfWeek + 5) % 7]
        
        guard let horarios = customHorarios[date] ?? horarioSemanal[dayName] else {
            return nil
        }
        
        return horarios.map { horario in
            let components = calendar.dateComponents([.hour, .minute], from: horario)
            return calendar.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: date) ?? date
        }
    }

    private func removeExcepcion(_ excepcion: ExcepcionFecha) {
        excepcionesFechas.removeAll { $0.id == excepcion.id }
        showGuardarCambios = true
    }
    
    private func formattedTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "America/Mexico_City")
        return formatter.string(from: date)
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Text("Define tu horario semanal y remueve las fechas que no deseas en la vista de calendario.")
                .font(.system(size: 16))
                .foregroundColor(Color.primary)
                .lineSpacing(5)
                .padding(.horizontal, 20)
        }
    }
    
    private var tabSelectionSection: some View {
        HStack(spacing: 10) {
            tabButton(title: "Días de la Semana", tab: "Dias")
            tabButton(title: "Calendario", tab: "Calendario")
        }
        .padding(.horizontal, 18)
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
                .padding(.vertical, -5)
                .frame(maxWidth: .infinity)
                .background(selectedTab == tab ? Color("btBlue") : Color.white)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color("btBlue"), lineWidth: 2))
                .cornerRadius(15)
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
            HStack {
                Text(day)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(Color("btBlue"))
                Spacer()
                addHorarioButton(for: day)
            }
            .padding(.horizontal, 20)
            
            let dayAbbr = dayAbbreviations[daysOfWeek.firstIndex(of: day)!]
            if let horariosDelDia = horarioSemanal[dayAbbr] {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                    ForEach(horariosDelDia, id: \.self) { horario in
                        horarioItem(day: day, horario: horario)
                    }
                }
                .padding(.horizontal, 12)
            }
//                else {
//                Text("No hay horarios para este día")
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//                    .padding(.horizontal, 20)
//            }
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
                Image(systemName: "xmark.circle")
                    .foregroundColor(Color("btBlue"))
                    .padding(.trailing, 5)
            }
        }
    }
    
    private func addHorarioButton(for day: String) -> some View {
        Button(action: {
            selectedDay = day
            showingTimePicker = true
        }) { Image(systemName: "plus.circle.fill")
                .font(.system(size: 24))
        }
    }
    
    private var calendarioView: some View {
        ScrollView {
            VStack {
                DatePicker("Seleccionar fecha", selection: $selectedCalendarDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .onChange(of: selectedCalendarDate) { old, new in
                        updateDisabledHorariosForSelectedDate()
                    }
                
                Text("Horarios:")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("btBlue"))
                    .padding(.top, 5)
                
                if let horarios = getHorariosForDate(selectedCalendarDate) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(horarios, id: \.self) { horario in
                            calendarHorarioItem(horario: horario)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    Text("No hay horarios para esta fecha")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
            }
            .padding(.top, -20)
            .padding(.bottom, 120)
        }
        .onAppear {
            updateDisabledHorariosForSelectedDate()
        }
    }
    
    private func calendarHorarioItem(horario: Date) -> some View {
        let isDisabled = isHorarioDisabled(horario)
        return Button(action: {
            toggleHorario(horario)
        }) {
            Text(formattedTime(for: horario))
                .font(.system(size: 16))
                .foregroundColor(isDisabled ? .white : Color("btBlue"))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(width: 100)
                .background(isDisabled ? Color.gray : Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(isDisabled ? Color.gray : Color("btBlue"), lineWidth: 2))
        }
    }
    
    
    private func isHorarioDisabled(_ horario: Date) -> Bool {
        disabledHorarios.contains(horario)
    }
    
    private func toggleHorario(_ horario: Date) {
        let combinedDateTime = combineDateAndTime(date: selectedCalendarDate, time: horario)
        
        if isHorarioDisabled(horario) {
            disabledHorarios.remove(horario)
            excepcionesFechas.removeAll { $0.fechaHora == combinedDateTime }
        } else {
            disabledHorarios.insert(horario)
            let newExcepcion = ExcepcionFecha(fechaHora: combinedDateTime, razon: "Horario deshabilitado")
            excepcionesFechas.append(newExcepcion)
        }
        
        updateAvailability()
        showGuardarCambios = true
    }
    
    private func updateDisabledHorariosForSelectedDate() {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: selectedCalendarDate)
        let dayKey = dayAbbreviations[dayOfWeek - 1]
        
        let allPossibleTimes = Set(getHorariosForDate(selectedCalendarDate) ?? [])
        print("All possible times for selected date: \(allPossibleTimes)")
        
        let exceptionsForSelectedDate = excepcionesFechas.filter { excepcion in
            calendar.isDate(excepcion.fechaHora, inSameDayAs: selectedCalendarDate)
        }
        print("Exceptions for selected date: \(exceptionsForSelectedDate)")
        
        let disabledHorariosForSelectedDate = Set(exceptionsForSelectedDate.compactMap { excepcion -> Date? in
            let components = calendar.dateComponents([.hour, .minute], from: excepcion.fechaHora)
            guard let hour = components.hour, let minute = components.minute else {
                return nil
            }
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: selectedCalendarDate)
        })
        print("Disabled horarios for selected date: \(disabledHorariosForSelectedDate)")
        
        disabledHorarios = disabledHorariosForSelectedDate
        print("Updated disabled horarios: \(disabledHorarios)")
    }
    
    private var timePickerModal: some View {
        VStack {
            DatePicker("", selection: $newHorario, displayedComponents: .hourAndMinute)
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
                    let dayAbbr = dayAbbreviations[daysOfWeek.firstIndex(of: selectedDay)!]
                    if horarioSemanal[dayAbbr] == nil {
                        horarioSemanal[dayAbbr] = []
                    }
                    if !horarioSemanal[dayAbbr]!.contains(where: { calendar.dateComponents([.hour, .minute], from: $0) == newHourMinute }) {
                        horarioSemanal[dayAbbr]?.append(newHorario)
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
        .cornerRadius(15)
        .padding(.horizontal, 20)
        .presentationDragIndicator(.visible)
        .presentationDetents([.height(400)])
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
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

struct ExcepcionFecha: Identifiable {
    let id = UUID()
    let fechaHora: Date
    let razon: String
}

#Preview {
    NavigationView {
        AppointmentScheduleView()
            .environmentObject(AuthModel())
    }
}
