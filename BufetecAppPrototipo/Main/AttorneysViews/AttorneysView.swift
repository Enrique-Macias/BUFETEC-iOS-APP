//
//  AttorneysView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/18/24.
//

import SwiftUI

struct AttorneysView: View {
    @State private var attorneys: [Attorney] = [
        Attorney(
            name: "Alfonso Muñoz",
            specialty: "Abogado Familiar",
            description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its It is a long established fact that a reader...",
            schedule: "Lunes, Miércoles y Jueves de 1 a 5 P.M.",
            examples: "It is a long established fact that a reader will be distracted by the readable..."
        ),
        Attorney(
            name: "Bruno García",
            specialty: "Abogado Familiar",
            description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its It is a long established fact that a reader...",
            schedule: "Lunes, Miércoles y Jueves de 1 a 5 P.M.",
            examples: "It is a long established fact that a reader will be distracted by the readable..."
        ),
        Attorney(
            name: "Mauricio Pineda",
            specialty: "Abogado Familiar",
            description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its It is a long established fact that a reader...",
            schedule: "Lunes, Miércoles y Jueves de 1 a 5 P.M.",
            examples: "It is a long established fact that a reader will be distracted by the readable..."
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header de la vista con el título y la barra de búsqueda
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("NUESTROS ABOGADOS")
                                .font(CustomFonts.PoppinsExtraBold(size: 32))
                                .foregroundColor(Color("btBlue"))
                            Spacer()
                        }
                        .padding(.horizontal)

                        // Barra de búsqueda (Placeholder)
                        HStack {
                            TextField("Buscar...", text: .constant(""))
                                .padding(.leading, 10)
                                .frame(height: 40)
                                .background(Color.clear)
                                .cornerRadius(10)
                            
                            Image(systemName: "magnifyingglass")
                                .padding(.trailing, 10)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("btBlue"), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)

                    // Lista de abogados
                    ForEach($attorneys) { $attorney in
                        AttorneyCard(attorney: $attorney)
                    }
                }
                .padding(.bottom, 30)
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

#Preview {
    AttorneysView()
        .environment(AppearanceManager())
}
