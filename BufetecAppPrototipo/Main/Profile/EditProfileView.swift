import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    @State private var nombreCompleto: String = ""
    @State private var genero: String = ""
    @State private var fechaNacimiento: Date = Date()
    @State private var numeroCelular: String = ""
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    let generos = ["Masculino", "Femenino", "Otro"]
    
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color("btBackground")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
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
                    VStack(spacing: 15) {
                        InputField(icon: "person", placeholder: "Nombre Completo", text: $nombreCompleto)
                        InputField(icon: "phone", placeholder: "Número Celular", text: $numeroCelular)
                            .keyboardType(.phonePad)
                        
                        genderPicker
                        birthdatePicker
                    }
                    .padding(.horizontal)
                    
                    saveButton
                }
                .padding()
            }
        }
        .navigationTitle("Editar Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                .onChange(of: selectedImage) { oldValue, newValue in
                    if let newImage = selectedImage {
                        profileImage = Image(uiImage: newImage)
                    }
                }
        }
        .onAppear {
            loadUserData()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var genderPicker: some View {
        Menu {
            ForEach(generos, id: \.self) { gender in
                Button(gender) { genero = gender }
            }
        } label: {
            HStack {
                Image(systemName: "person")
                Text(genero.isEmpty ? "Género" : genero)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
            .accentColor(.primary)
            .background(colorScheme == .dark ? Color.clear : Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
            )
        }
    }
    
    private var birthdatePicker: some View {
        HStack {
            Image(systemName: "calendar")
            Text("Fecha de nacimiento")
            Spacer()
            DatePicker("", selection: $fechaNacimiento, displayedComponents: [.date])
                .labelsHidden()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
        .background(colorScheme == .dark ? Color.clear : Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
        )
    }
    
    private var saveButton: some View {
        Button(action: saveChanges) {
            Text("Guardar Cambios")
                .font(CustomFonts.MontserratBold(size: 16))
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                .background(colorScheme == .light ? Color.black : Color.white)
                .cornerRadius(16)
        }
    }
    
    private func loadUserData() {
        nombreCompleto = authModel.userData.nombre
        genero = authModel.userData.genero
        numeroCelular = authModel.userData.celular
        
        if let date = dateFormatter.date(from: authModel.userData.fechaDeNacimiento) {
            fechaNacimiento = date
        } else {
            print("Failed to parse date: \(authModel.userData.fechaDeNacimiento)")
            fechaNacimiento = Date()
        }
    }
    
    private func saveChanges() {
        Task {
            do {
                let birthDateString = dateFormatter.string(from: fechaNacimiento)
                
                try await authModel.updateUserProfile(
                    name: nombreCompleto,
                    phone: numeroCelular,
                    gender: genero
                )
                
                // Update birth date separately as it's not included in updateUserProfile
                try await authModel.updateUserInfo(fields: ["fechaDeNacimiento": birthDateString])
                
                dismiss()
            } catch {
                errorMessage = "Failed to update profile: \(error.localizedDescription)"
                showErrorAlert = true
            }
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
        .environmentObject(AuthModel())
}
