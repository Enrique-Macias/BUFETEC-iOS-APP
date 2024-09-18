//
//  Attorneys.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/18/24.
//

import SwiftUI

struct Attorney: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let description: String
    let schedule: String
    let examples: String
    var isExpanded: Bool = false
}

struct AttorneyCard: View {
    @Binding var attorney: Attorney
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Imagen del abogado (Placeholder)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("btBlue"))
                
                VStack(alignment: .leading) {
                    Text(attorney.name)
                        .font(CustomFonts.PoppinsBold(size: 16))
                        .foregroundColor(Color("btBlue"))
                    
                    Text(attorney.specialty)
                        .font(CustomFonts.MontserratMedium(size: 12))
                        .foregroundColor(Color("btBlue"))
                }
                
                Spacer()
                
                // Botón de expandir/contraer
                Button(action: {
                    attorney.isExpanded.toggle()
                }) {
                    Image(systemName: attorney.isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("btBlue"))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            // Contenido expandido
            if attorney.isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Descripción:")
                        .font(CustomFonts.PoppinsBold(size: 14))
                        .foregroundColor(Color("btBlue"))
                    
                    Text(attorney.description)
                        .font(CustomFonts.MontserratMedium(size: 14))
                        .foregroundColor(.black)
                    
                    Text("Horario:")
                        .font(CustomFonts.PoppinsBold(size: 14))
                        .foregroundColor(Color("btBlue"))
                    
                    Text(attorney.schedule)
                        .font(CustomFonts.MontserratMedium(size: 14))
                        .foregroundColor(.black)
                    
                    Text("Ejemplos de Casos:")
                        .font(CustomFonts.PoppinsBold(size: 14))
                        .foregroundColor(Color("btBlue"))
                    
                    Text(attorney.examples)
                        .font(CustomFonts.MontserratMedium(size: 14))
                        .foregroundColor(.black)
                    
                    // Botón de Agendar Cita
                    Button(action: {
                        // Acción para agendar cita
                    }) {
                        HStack {
                            Text("Agendar Cita")
                                .font(CustomFonts.PoppinsSemiBold(size: 16))
                            
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("btBlue"))
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
    }
}
