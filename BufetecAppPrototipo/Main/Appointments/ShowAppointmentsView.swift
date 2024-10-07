//
//  ShowAppointmentsView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/26/24.
//

import SwiftUI

// Vista para mostrar las citas programadas o un mensaje de "sin citas"
struct ShowAppointmentsView: View {
    
    // Simular si hay citas programadas o no
    @State private var appointments: [Appointment] = [
        Appointment(lawyerName: "Bruno García", specialty: "Abogado Familiar", reason: "Asesoría Legal", date: Date(), timeRange: "10:30 - 11:30", location: "Av. Eugenio Garza Sada Sur 427, Alta Vista, 64840 Monterrey, N.L.")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Título
                    Text("CITAS")
                        .font(CustomFonts.PoppinsBold(size: 35))
                        .foregroundColor(Color("btBlue"))
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    // Condicional para mostrar citas o mensajes de "sin citas"
                    if appointments.isEmpty {
                        NoAppointmentsView()
                    } else {
                        // Muestra las citas programadas
                        ForEach(appointments) { appointment in
                            AppointmentCard(appointment: appointment)
                                .padding(.horizontal, 20)
                        }
                        
                        // Citas pasadas (en este caso, vacías o estáticas)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Citas Pasadas")
                                .font(CustomFonts.PoppinsBold(size: 18))
                                .foregroundColor(Color("btBlue"))
                                .padding(.horizontal, 20)
                            
                            ForEach(appointments) { appointment in
                                AppointmentCard(appointment: appointment)
                                    .padding(.horizontal, 20)
                                    .opacity(0.5) // Citas pasadas con opacidad
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
}

// Vista para mostrar si no hay citas
struct NoAppointmentsView: View {
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("btBlue"), lineWidth: 1)
                    .frame(height: 100)
                    .overlay(
                        Text("Sin Citas Previas")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(Color("btBlue"))
                    )
            }
            .padding(.horizontal, 20)
            
            VStack {
                Text("Citas Pasadas")
                    .font(CustomFonts.PoppinsBold(size: 18))
                    .foregroundColor(Color("btBlue"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("btBlue"), lineWidth: 1)
                    .frame(height: 100)
                    .overlay(
                        Text("Sin Citas Previas")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(Color("btBlue"))
                    )
            }
            .padding(.horizontal, 20)
        }
    }
}

// Modelo de citas
struct Appointment: Identifiable {
    let id = UUID()
    var lawyerName: String
    var specialty: String
    var reason: String
    var date: Date
    var timeRange: String
    var location: String
}

// Card de una cita programada
struct AppointmentCard: View {
    var appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle()) // Imagen redonda (como en el prototipo)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(appointment.lawyerName)
                        .font(CustomFonts.PoppinsBold(size: 20))
                        .foregroundColor(.white)
                    
                    Text(appointment.specialty)
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Motivo: \(appointment.reason)")
                    .font(CustomFonts.PoppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                
                Text("Ubicación: \(appointment.location)")
                    .font(CustomFonts.MontserratRegular(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Fecha y Hora
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("btBlue"))
                    Text("\(appointment.date, formatter: dateFormatter)")
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(Color("btBlue"))
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                        .foregroundColor(Color("btBlue"))
                    Text(appointment.timeRange)
                        .font(CustomFonts.MontserratRegular(size: 14))
                        .foregroundColor(Color("btBlue"))
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                
                Spacer()
                
                // Botón de cancelar
                Button(action: {
                    // Acción para cancelar la cita
                }) {
                    Text("CANCELAR")
                        .font(CustomFonts.PoppinsSemiBold(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .background(Color("btBlue"))
                .cornerRadius(5)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color("btBlue"))
        .cornerRadius(15)
    }
}

// Formato de fecha
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_ES") // Cambiar a español
    formatter.dateFormat = "EEE, d MMM yyyy"
    return formatter
}()

// Vista previa
#Preview {
    ShowAppointmentsView()
        .environment(\.colorScheme, .light)
}
