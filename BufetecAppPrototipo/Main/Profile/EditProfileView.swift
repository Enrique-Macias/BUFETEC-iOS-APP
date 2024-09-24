import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var nombreCompleto: String = "Bruno García"
    @State private var genero: String = "Masculino"
    @State private var fechaNacimiento: String = "05/01/1995"
    @State private var numeroCelular: String = "+52 81 1234 5678"
    @State private var correoElectronico: String = "bruno.garcia@bufetec.mx"
    
    @State private var selectedGender: String = "Masculino"
    let generos = ["Masculino", "Femenino"]
    
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tintColor]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Profile Image
                    VStack {
                        profileImage?
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.accentColor)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.accentColor, lineWidth: 2)
                            )
                            .onTapGesture {
                                showingImagePicker = true
                                sourceType = .photoLibrary
                            }
                        
                        Button(action: {
                            showingImagePicker = true
                            sourceType = .photoLibrary
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.cyan)
                                .offset(x: 30, y: -25)
                        }
                    }
                                        
                    // Form Fields
                    VStack(spacing: 20) {
                        CustomTextField(title: "Nombre Completo", text: $nombreCompleto)
                        
                        HStack {
                            CustomPicker(title: "Género", selection: $selectedGender, options: generos)
                            CustomTextField(title: "Fecha de Nacimiento", text: $fechaNacimiento)
                        }
                        
                        CustomTextField(title: "Número Celular", text: $numeroCelular)
                        
                        CustomTextField(title: "Correo Electrónico", text: $correoElectronico)
                    }
                    .padding(.horizontal)
                    
                    // Save Button
                    Button(action: {
                        // Save action
                    }) {
                        Text("Guardar")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 40)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.top, 15)
                }
                .padding(.vertical)
            }
            .navigationTitle("Mi Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .background(Color("btBackground"))
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                .onChange(of: selectedImage) { oldValue, newValue in
                    if let newImage = selectedImage {
                        profileImage = Image(uiImage: newImage)
                    }
                }
        }
    }
}

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.accentColor)
            
            TextField("", text: $text)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
        }
    }
}

struct CustomPicker: View {
    var title: String
    @Binding var selection: String
    var options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.accentColor)
            
            Picker(selection: $selection, label: Text(selection)) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .padding(.vertical, -6)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
        }
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
