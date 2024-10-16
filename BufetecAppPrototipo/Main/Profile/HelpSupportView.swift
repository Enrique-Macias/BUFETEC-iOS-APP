//
//  HelpSupportView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 10/15/24.
//

import SwiftUI

struct HelpSupportView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Preguntas Frecuentes")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("btBlue"))
                    
                    Text("Aquí encontrarás información importante sobre Bufetec.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    ForEach(bufetecHELP) { question in
                        HelpCard(question: question)
                    }
                }
                .padding()
            }
            .background(Color("btBackground"))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HelpCard: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded: Bool = false
    var question: Question
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(Color("btBlue"))
                    .font(.system(size: 24))
                
                Text(question.text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("btBlue"))
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(Color("btBlue"))
                    .font(.system(size: 14))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Text(question.details)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .padding(.leading, 30)
                    .transition(.opacity)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.gray.opacity(0.15) : Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("btBlue").opacity(0.5), lineWidth: 1)
        )
    }
}

let bufetecHELP = [
    Question(text: "¿Cuál es el costo de los servicios de Bufetec?",
             details: "Bufetec ofrece asesoría jurídica completamente gratuita como parte de su servicio comunitario. Para trámites notariales, facilitamos el proceso a un costo menor, manteniendo la calidad legal."),
    Question(text: "¿Quiénes pueden acceder a los servicios de Bufetec?",
             details: "Nuestros servicios están disponibles para personas de escasos recursos que viven en las zonas cercanas al Tec de Monterrey, Campus Monterrey, así como para toda la comunidad interna del Tec."),
    Question(text: "¿Qué tipos de trámites realiza Bufetec?",
             details: "Realizamos diversos trámites, incluyendo: Constitución de Sociedad/Asociación, Protocolización de Actas, Otorgamiento de Poderes, Copias Certificadas, Protocolización de Contratos, Cancelación de Hipoteca, Adjudicación por Herencia, Radicación Testamentaria e Intestamentaria, Información Testimonial, y Testamentos."),
    Question(text: "¿Cómo trabaja Bufetec?",
             details: "Bufetec es una asociación interna de la Comunidad Tec, formada por estudiantes de Derecho y otras carreras. Trabajamos en colaboración con la Notaría No. 115 del Lic. Jesús Córdova Gálvez para garantizar la legalidad de los trámites. La Lic. Juana Miranda Cruz coordina la asesoría jurídica."),
    Question(text: "¿Cuánto tiempo lleva operando Bufetec?",
             details: "Bufetec se fundó en el año 2000. Desde entonces, hemos manejado alrededor de 300 juicios legales y tramitado más de 600 Testamentos, siendo este último uno de nuestros principales servicios para la Comunidad Tec y zonas aledañas.")
]

#Preview {
    HelpSupportView()
}
