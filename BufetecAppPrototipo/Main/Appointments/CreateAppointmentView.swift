//
//  CreateAppointmentView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/24/24.
//

import SwiftUI

struct CreateAppointmentView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Título de la vista
                Text("Agendar Cita")
                    .font(CustomFonts.PoppinsBold(size: 32))
                    .foregroundColor(Color("btBlue"))
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                
                // Card con la información del abogado
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("btBlue"))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bruno García")
                            .font(CustomFonts.PoppinsBold(size: 18))
                            .foregroundColor(Color("btBlue"))
                        
                        Text("Abogado Familiar")
                            .font(CustomFonts.MontserratMedium(size: 14))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 10) {
                            HStack(spacing: 5) {
                                Image(systemName: "phone.fill")
                                Text("81 1234 5678")
                            }
                            .font(CustomFonts.MontserratMedium(size: 14))
                            .foregroundColor(Color("btBlue"))
                            
                            HStack(spacing: 5) {
                                Image(systemName: "envelope.fill")
                                Text("bruno@bufetec.mx")
                            }
                            .font(CustomFonts.MontserratMedium(size: 14))
                            .foregroundColor(Color("btBlue"))
                        }
                        
                        HStack(spacing: 5) {
                            Image(systemName: "mappin.and.ellipse")
                            Text("C. Av. Luis Elizondo y Garza Sada,\nTecnológico, 64700 Monterrey, N.L.")
                                .font(CustomFonts.MontserratMedium(size: 14))
                        }
                        .foregroundColor(Color("btBlue"))
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("btBlue"), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Acción para regresar a la vista anterior
                    }) {
                        Image(systemName: "arrow.backward.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color("btBlue"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("btIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("btBlue"))
                        .frame(width: 35, height: 35)
                }
            }
        }
    }
}

#Preview {
    CreateAppointmentView()
        .environment(AppearanceManager())
}
