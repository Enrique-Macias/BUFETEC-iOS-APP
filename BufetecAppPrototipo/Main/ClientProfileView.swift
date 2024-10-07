//
//  ClientProfileView.swift
//  BufetecAppPrototipo
//
//  Created by Μιτχελλ on 23/09/24.
//

import SwiftUI

struct ClientProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(uiImage: UIImage(named: "placeholderProfileImage") ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(50)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Stephan Guy")
                            .font(.custom("Poppins-Bold", size: 30))
                            .foregroundColor(Color( "btBlue"))
                        
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("#902a")
                                .font(.custom("Poppins", size: 14))
                                .foregroundColor(Color.black)
                                .padding(.horizontal,10)
                            
                            Text("Cliente")
                                .font(.custom("Poppins", size: 14))
                                .foregroundColor(Color.black)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 17)
                .padding(.top, 30)
                .padding(.bottom, 30)
                
                VStack(){
                    HStack {
                        Text("Caso:")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(Color.black)
                        
                        Text("Mercantil")
                            .font(.custom("Poppins", size: 14))
                            .foregroundColor(Color.black)
                        
                        Spacer().frame(width: 60)
                        
                        Text("Estado:")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(Color.black)
                        
                        
                        Text("En proceso")
                            .font(.custom("Poppins", size: 14))
                            .foregroundColor(Color.black)
                        
                        
                    }
                    
                }
                
                
                VStack(alignment: .leading) {
                    Text("Fechas")
                        .font(.custom("Poppins-Bold", size: 20))
                        .padding(.bottom, 5)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            let items: [(String, String,String)] = [
                                ("Completa", "Reunión con asesor","01/01/2024"),
                                ("Pendiente", "Presentación de demanda","01/01/2024"),
                            ]
                            
                            ForEach(items, id: \.0) { item in
                                
                                Text(item.0)
                                     .font(.custom("Poppins-Bold", size: 14))
                                     .foregroundColor(item.0 == "Completa" ? .green : (item.0 == "Pendiente" ? .orange : .black))
                                     .frame(maxWidth: .infinity, alignment: .leading) // Ensure this stretches to full width and aligns left
                                     .padding(.horizontal, 0)

                                 VStack(alignment: .leading) {
                                     Text(item.1)
                                         .font(.custom("Poppins-SemiBold", size: 14))
                                         .foregroundColor(.black)
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                         .padding(.horizontal, 0)

                                     Text(item.2)
                                         .font(.custom("Poppins", size: 12))
                                         .foregroundColor(.gray)
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                         .padding(.horizontal, 0)
                                 }
                                 .padding(.horizontal, 0)
                             }
                             .padding(.leading, 15)
                        }
                        .padding(.vertical,5)
                    }
                    .padding(15)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(0)
                }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                    
                
                .padding(.bottom,0)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Detalles")
                            .font(.custom("Poppins-Bold", size: 20))
                            .padding(.bottom, 5)

                        Text("Descripción del cliente")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .padding(.bottom, 2)
                        Text("“Estoy enfrentando un problema legal con un cliente que no ha cumplido con el pago de una factura por servicios prestados. He intentado varias veces comunicarme con ellos, pero no he recibido respuesta. Necesito orientación sobre cómo proceder bajo la ley mercantil para recuperar el monto adeudado.”")
                            .font(.custom("Poppins-Regular", size: 14))
                            .padding(.bottom, 10)

                        Text("Evaluación del asistente al cliente")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .padding(.bottom, 2)
                        Text("“Te recomiendo informar de inmediato a nuestro abogado asesor sobre tu situación de incumplimiento de pago, ya que este es un caso de derecho mercantil. Ellos podrán guiarte sobre los pasos legales a seguir para resolver tu caso y asegurarte de que recibas el apoyo necesario para proteger tus derechos.”")
                            .font(.custom("Poppins-Regular", size: 14))
                            .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.leading, 15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("btIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 20)
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        
    }
}

#Preview {
    ClientProfileView()
}
