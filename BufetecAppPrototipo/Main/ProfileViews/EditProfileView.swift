//
//  EditProfileView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/11/24.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var nombreCompleto: String = "Bruno García"
    @State private var genero: String = "Masculino"
    @State private var fechaNacimiento: String = "05/01/1995"
    @State private var numeroCelular: String = "+52 81 1234 5678"
    @State private var correoElectronico: String = "bruno.garcia@bufetec.mx"
    
    // Para el picker de género
    @State private var selectedGender: String = "Masculino"
    let generos = ["Masculino", "Femenino"]
    
    // Para la selección de la imagen
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer()
                    
                    // Imagen de perfil
                    VStack {
                        profileImage?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.black)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color("btBlue"), lineWidth: 2)
                            )
                            .onTapGesture {
                                showingImagePicker = true
                                sourceType = .photoLibrary
                            }
                        
                        // Botón para cambiar la imagen de perfil
                        Button(action: {
                            showingImagePicker = true
                            sourceType = .photoLibrary // Cambiar para seleccionar desde el carrete
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("btBlue"))
                                .offset(x: 35, y: -30)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 0.5)
                        .background(Color("btBlue"))
                    
                    Spacer(minLength: 20)
                    
                    // Nombre completo
                    CustomTextField(title: "Nombre Completo", text: $nombreCompleto)
                    
                    // Picker para el género y TextField para la fecha de nacimiento
                    HStack {
                        VStack {
                            Text("Género")
                                .font(CustomFonts.PoppinsSemiBold(size: 12))
                                .foregroundColor(Color("btBlue"))
                                .padding(.leading, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Picker(selection: $selectedGender, label: Text(genero).foregroundColor(Color("btBlue"))) {
                                ForEach(generos, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .frame(height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("btBlue"), lineWidth: 1)
                            )
                        }
                        
                        CustomTextField(title: "Fecha de Nacimiento", text: $fechaNacimiento)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    
                    // Número Celular
                    CustomTextField(title: "Número Celular", text: $numeroCelular)
                        .keyboardType(.phonePad)
                    
                    // Correo electrónico
                    CustomTextField(title: "Correo Electrónico", text: $correoElectronico)
                        .keyboardType(.emailAddress)
                    
                    // Botón Guardar
                    Button(action: {
                        // Acción de guardar cambios
                    }) {
                        Text("Guardar")
                            .font(CustomFonts.PoppinsSemiBold(size: 16))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color("btBlue"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 30)
                    }
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Mi Perfil")
                            .font(CustomFonts.PoppinsBold(size: 20))
                            .foregroundColor(Color("btBlue"))
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Acción para cerrar la vista
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(Color("btBlue"))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image("btIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundStyle(Color("btBlue"))
                            .frame(width: 27, height: 27)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                    .onChange(of: selectedImage) {
                        if let newImage = selectedImage {
                            profileImage = Image(uiImage: newImage)
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Componente para el campo de texto con estilo personalizado
struct CustomTextField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(CustomFonts.PoppinsSemiBold(size: 12))
                .foregroundColor(Color("btBlue"))
                .padding(.leading, 5)
            
            TextField("", text: $text)
                .padding()
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("btBlue"), lineWidth: 1)
                )
        }
        .padding(.bottom, 10)
    }
}

// ImagePicker para seleccionar imagen del carrete o tomar una foto
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    EditProfileView()
        .environment(AppearanceManager())
}
