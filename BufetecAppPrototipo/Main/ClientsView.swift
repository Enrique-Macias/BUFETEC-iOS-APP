//
//  ClientsView.swift
//  BufetecAppPrototipo
//
//  Created by Michelle on 23/09/24.
//

import SwiftUI
import Kingfisher

struct ClientsView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Text("Administrar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    
                    Button(action: {
                        
                    }) {
                        Text("Ordenar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 17)
                .padding(.top, 30)
                .padding(.bottom,10)
                ScrollView(){
                    
                    VStack(spacing: 10) {
                        CustomCardClient(name: "Stephan Guy", casoNum: "#153a", casoTipo: "Caso civil",image:UIImage(named: "placeholderProfileImage") ?? UIImage())
                        CustomCardClient(name: "Guy Stephani", casoNum: "#153b", casoTipo: "Caso familiar",image:UIImage(named: "placeholderProfileImage") ?? UIImage())
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
        }
    }}



struct CustomCardClient: View {
    @Environment(\.colorScheme) var colorScheme
    var name: String
    var casoNum: String
    var casoTipo: String
    var image: UIImage

    @State private var isPressed = false

    var body: some View {
        HStack {
            // Image on the left
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(50)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.system(size:     16, weight: .bold))
                    .foregroundColor(Color.black)

                Text(casoNum)
                    .font(.system(size: 16))
                    .lineSpacing(5)
                    .foregroundStyle(.primary)

                Text(casoTipo)
                    .font(.system(size: 16))
                    .lineSpacing(5)
                    .foregroundStyle(.primary)
            }
            .padding(.leading, 10) // Space between image and text

            Spacer() // Push the arrow button to the right
            
            // Arrow button on the far right
            NavigationLink(destination: ClientProfileView()) {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.blue)
                                .padding()
                        }
        }
        .padding(20)
        .background(colorScheme == .dark ? Color.gray.opacity(0.15) : Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ClientsView()
}

