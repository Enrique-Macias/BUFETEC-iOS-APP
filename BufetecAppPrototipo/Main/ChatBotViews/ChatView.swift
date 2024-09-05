//
//  ChatView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/5/24.
//

import SwiftUI

struct ChatView: View {
    @State private var userInput: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                // Consulta de procedimientos con el ícono de lápiz
                VStack {
                    Image("edit-2")
                        .font(.system(size: 32))
                        .foregroundColor(Color(.black))
                        .padding(.bottom, 4)
                    
                    Text("Consulta de procedimientos")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color(.black))
                        .padding(.bottom, 20)

                    // Botones de preguntas predefinidas
                    VStack(spacing: 12) {
                        Button(action: {
                            // Acción para la primera pregunta
                        }) {
                            Text("¿Cómo se cuál es mi procedimiento legal?")
                                .frame(maxWidth: .infinity, maxHeight: 15)
                                .fontWeight(.light)
                                .padding()
                                .foregroundColor(.primary)
                                .background(Color.clear)
                                .cornerRadius(30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            // Acción para la segunda pregunta
                        }) {
                            Text("¿Que papelería debo tener a la mano?")
                                .frame(maxWidth: .infinity, maxHeight: 15)
                                .fontWeight(.light)
                                .padding()
                                .foregroundColor(.primary)
                                .background(Color.clear)
                                .cornerRadius(30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                        }

                        Button(action: {
                            // Acción para la tercera pregunta
                        }) {
                            Text("¿Cómo se cuál procedimiento tomar?")
                                .frame(maxWidth: .infinity, maxHeight: 15)
                                .fontWeight(.light)
                                .padding()
                                .foregroundColor(.primary)
                                .background(Color.clear)
                                .cornerRadius(30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()

                // Barra de ingreso de preguntas con TextField
                HStack {
                    TextField("Genera tu propia pregunta", text: $userInput)
                        .padding(10)
                        .foregroundColor(Color("btBlue"))
                        .background(Color.clear)
                        .cornerRadius(8)

                    // Micrófono
                    Button(action: {
                        // Acción para grabar pregunta por voz
                    }) {
                        Image("microphone-2")
                            .font(.system(size: 20))
                            .padding(.trailing, 1)
                            .foregroundStyle(Color(.gray))
                    }
                    
                    // Botón de enviar pregunta
                    Button(action: {
                        // Acción para enviar la pregunta
                    }) {
                        Image("send")
                            .font(.system(size: 20))
                            .padding(1)
                    }
                    .padding(.trailing, 10)
                }
                .frame(height: 55)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Acción para volver atrás
                    }) {
                        Image("arrow-left")
                            .font(.system(size: 20))
                            .foregroundColor(Color("btBlue"))
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("BOT-logo")
                            .font(.system(size: 24))
                            .foregroundColor(Color("btBlue"))
                        Text("Asistente")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color("btBlue"))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 15) {
                        Button(action: {
                            // Acción para sonido
                        }) {
                            Image("volume-high")
                                .font(.system(size: 20))
                        }
                        
                        Button(action: {
                            // Acción para recargar
                        }) {
                            Image("export")
                                .font(.system(size: 20))
                                .foregroundStyle(Color(.gray))
                        }
                    }
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatView()
                .preferredColorScheme(.light)
            ChatView()
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ChatView()
}
