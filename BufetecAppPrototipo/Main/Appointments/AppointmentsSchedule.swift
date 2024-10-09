//
//  AppointmentsSchedule.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 10/8/24.
//

import SwiftUI

struct AppointmentScheduleView: View {
    @State private var selectedTab: String = "Dias"
    @State private var horarios: [String: [Date]] = [:] // Horarios para "Días de la Semana"
    @State private var selectedDay: String = ""
    @State private var showingTimePicker = false
    @State private var newHorario = Date()
    @State private var showGuardarCambios = false
    @State private var showSuccessAlert = false
    @State private var shouldHideGuardarCambios = false
    
    @State private var selectedCalendarDate = Date() // Para el calendario
    @State private var customHorarios: [Date: [Date]] = [:] // Horarios específicos por fecha
    
    private let daysOfWeek = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    // Título y descripción
                    Text("Definir Horarios")
                        .font(CustomFonts.PoppinsBold(size: 32))
                        .foregroundColor(Color("btBlue"))
                        .padding(.top, 40)
                        .padding(.leading, 20)
                    
                    Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its.")
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(Color.gray)
                        .lineSpacing(5)
                        .padding(.leading, 20)
                    
                    // Botones de Días de la Semana y Calendario
                    HStack(spacing: 10) {
                        Button(action: {
                            selectedTab = "Dias"
                        }) {
                            Text("Días de la Semana")
                                .font(CustomFonts.PoppinsSemiBold(size: 14))
                                .foregroundColor(selectedTab == "Dias" ? Color.white : Color("btBlue"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == "Dias" ? Color("btBlue") : Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("btBlue"), lineWidth: 2))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            selectedTab = "Calendario"
                            syncHorariosWithCalendar() // Sincronizar los horarios cuando se cambia a la vista Calendario
                        }) {
                            Text("Calendario")
                                .font(CustomFonts.PoppinsSemiBold(size: 14))
                                .foregroundColor(selectedTab == "Calendario" ? Color.white : Color("btBlue"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == "Calendario" ? Color("btBlue") : Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("btBlue"), lineWidth: 2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if selectedTab == "Dias" {
                        // Sección de Días de la Semana
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(day)
                                            .font(CustomFonts.PoppinsSemiBold(size: 16))
                                            .foregroundColor(Color("btBlue"))
                                            .padding(.leading, 20)
                                        
                                        if let horariosDelDia = horarios[day] {
                                            // Mostrar horarios agregados en filas de 3 por fila
                                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                                                ForEach(horariosDelDia, id: \.self) { horario in
                                                    HStack {
                                                        Text("\(formattedTime(for: horario))")
                                                            .font(CustomFonts.PoppinsMedium(size: 12))
                                                            .padding(.horizontal)
                                                            .padding(.vertical, 8)
                                                            .background(Color.white)
                                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("btBlue"), lineWidth: 2))
                                                            .cornerRadius(8)
                                                        
                                                        // Botón para eliminar horario
                                                        Button(action: {
                                                            if let index = horarios[day]?.firstIndex(of: horario) {
                                                                horarios[day]?.remove(at: index)
                                                                if horarios[day]?.isEmpty ?? true {
                                                                    horarios.removeValue(forKey: day)
                                                                }
                                                                showGuardarCambios = true // Mostrar el botón si hay cambios pendientes
                                                            }
                                                        }) {
                                                            Image(systemName: "xmark")
                                                                .foregroundColor(Color("btBlue"))
                                                                .padding(.trailing, 10)
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.leading, 20)
                                        }
                                        
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
                                }
                            }
                            .padding(.vertical, 20)
                        }
                    } else if selectedTab == "Calendario" {
                        // Mostrar el calendario
                        ScrollView {
                            VStack {
                                DatePicker("Seleccionar fecha", selection: $selectedCalendarDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                                    .onChange(of: selectedCalendarDate) { newDate in
                                        syncHorariosForSelectedDate(newDate) // Cargar horarios basados en el día de la semana
                                    }
                                
                                if let horariosFecha = customHorarios[selectedCalendarDate] {
                                    Text("Horarios:")
                                        .font(CustomFonts.PoppinsSemiBold(size: 16))
                                        .foregroundColor(Color("btBlue"))
                                        .padding(.leading, 20)
                                    
                                    // Mostrar horarios del día seleccionado
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                                        ForEach(horariosFecha, id: \.self) { horario in
                                            HStack {
                                                Text("\(formattedTime(for: horario))")
                                                    .font(CustomFonts.PoppinsMedium(size: 12))
                                                    .padding(.horizontal)
                                                    .padding(.vertical, 8)
                                                    .background(Color.white)
                                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("btBlue"), lineWidth: 2))
                                                    .cornerRadius(8)
                                                
                                                // Botón para eliminar horario
                                                Button(action: {
                                                    if let index = customHorarios[selectedCalendarDate]?.firstIndex(of: horario) {
                                                        customHorarios[selectedCalendarDate]?.remove(at: index)
                                                        if customHorarios[selectedCalendarDate]?.isEmpty ?? true {
                                                            customHorarios.removeValue(forKey: selectedCalendarDate)
                                                        }
                                                        showGuardarCambios = true // Mostrar el botón si hay cambios pendientes
                                                    }
                                                }) {
                                                    Image(systemName: "xmark")
                                                        .foregroundColor(Color("btBlue"))
                                                        .padding(.trailing, 10)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                                
                                Button(action: {
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
                            .padding(.vertical, 20)
                        }
                    }
                    
                    // Time Picker Modal para agregar horario
                    if showingTimePicker {
                        VStack {
                            DatePicker("Seleccionar Hora", selection: $newHorario, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                            
                            Button("Agregar") {
                                // Agregar horario seleccionado para el día en el calendario
                                if selectedTab == "Calendario" {
                                    if customHorarios[selectedCalendarDate] == nil {
                                        customHorarios[selectedCalendarDate] = []
                                    }
                                    customHorarios[selectedCalendarDate]?.append(newHorario)
                                } else if selectedTab == "Dias" {
                                    if !horarios.keys.contains(selectedDay) {
                                        horarios[selectedDay] = []
                                    }
                                    horarios[selectedDay]?.append(newHorario)
                                }
                                showingTimePicker = false
                                showGuardarCambios = true // Mostrar el botón al agregar un horario
                                shouldHideGuardarCambios = false
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
                }
                
                // Botón Guardar Cambios fuera del ScrollView (siempre visible)
                VStack {
                    Spacer()
                    if showGuardarCambios && !shouldHideGuardarCambios {
                        Button(action: {
                            // Ordenar horarios de menor a mayor para cada día
                            for day in horarios.keys {
                                horarios[day]?.sort(by: { $0 < $1 })
                            }
                            
                            for date in customHorarios.keys {
                                customHorarios[date]?.sort(by: { $0 < $1 })
                            }
                            
                            // Acción para guardar los cambios
                            showSuccessAlert = true
                            shouldHideGuardarCambios = true
                            
                            // Ocultar la alerta después de 2 segundos
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSuccessAlert = false
                            }
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
                // Alerta de éxito
                if showSuccessAlert {
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Acción para regresar o cerrar
                    }) {
                        Image("arrow-left")
                            .font(.system(size: 20))
                            .foregroundColor(Color("btBlue"))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image("btIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(Color("btBlue"))
                        .frame(width: 27, height: 27)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    // Función para sincronizar horarios del día de la semana con el calendario
    private func syncHorariosWithCalendar() {
        let calendar = Calendar.current
        for day in horarios.keys {
            if let dayIndex = daysOfWeek.firstIndex(of: day) {
                let currentDate = calendar.date(bySetting: .weekday, value: dayIndex + 2, of: selectedCalendarDate)
                if let date = currentDate, customHorarios[date] == nil {
                    customHorarios[date] = horarios[day]
                }
            }
        }
    }
    
    // Sincronizar horarios para el día seleccionado en el calendario
    private func syncHorariosForSelectedDate(_ date: Date) {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let dayName = daysOfWeek[dayOfWeek - 2] // Mapear el día de la semana
        if let horariosForDay = horarios[dayName] {
            customHorarios[date] = horariosForDay
        }
    }
    
    private func formattedTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    AppointmentScheduleView()
        .environment(AppearanceManager())
}
