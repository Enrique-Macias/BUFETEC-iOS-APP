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
    
    // Attorney-specific state variables
    @State private var isAttorney: Bool = false
    @State private var especialidad: String = ""
    @State private var descripcion: String = ""
    @State private var casosEjemplo: String = ""
    @State private var showingAttorneyFields: Bool = false
    
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
    
    private let baseURL = APIURL.default
    
    var body: some View {
        ZStack {
            Color("btBackground")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    profileImageSection
                    
                    if showingAttorneyFields {
                        attorneyFieldsSection
                    } else {
                        userFieldsSection
                    }
                    
                    if isAttorney {
                        toggleFieldsButton
                    }
                    
                    saveButton
                }
                .padding()
                .onTapGesture {
                    hideKeyboard()  // Ocultar teclado al tocar fuera de los campos de texto
                }
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
    
    private var profileImageSection: some View {
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
    }
    
    private var userFieldsSection: some View {
        VStack(spacing: 15) {
            InputField(icon: "person", placeholder: "Nombre Completo", text: $nombreCompleto)
            InputField(icon: "phone", placeholder: "Número Celular", text: $numeroCelular)
                .keyboardType(.phonePad)
            genderPicker
            birthdatePicker
        }
        .padding(.horizontal)
    }
    
    private var attorneyFieldsSection: some View {
        VStack(spacing: 15) {
            InputField(icon: "briefcase", placeholder: "Especialidad", text: $especialidad)
            InputField(icon: "doc.text", placeholder: "Casos Ejemplo", text: $casosEjemplo)
            CustomInputField(icon: "text.alignleft", placeholder: "Descripción", text: $descripcion, isMultiline: true)
            //            TextEditor(text: $descripcion)
            //                .frame(height: 100)
            //                .padding(8)
            //                .background(Color(.systemGray6))
            //                .cornerRadius(8)
            //                .overlay(
            //                    RoundedRectangle(cornerRadius: 8)
            //                        .stroke(Color.gray, lineWidth: 1)
            //                )
        }
        .padding(.horizontal)
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
    
    private var toggleFieldsButton: some View {
        Button(action: {
            withAnimation(.none) {
                showingAttorneyFields.toggle()
            }
        }) {
            Text(showingAttorneyFields ? "Mostrar Datos de Usuario" : "Mostrar Datos de Abogado")
                .font(CustomFonts.MontserratBold(size: 16))
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                .background(Color.accentColor)
                .cornerRadius(16)
        }
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
        isAttorney = authModel.userData.tipo == "abogado"
        
        if let date = dateFormatter.date(from: authModel.userData.fechaDeNacimiento) {
            fechaNacimiento = date
        } else {
            print("Failed to parse date: \(authModel.userData.fechaDeNacimiento)")
            fechaNacimiento = Date()
        }
        
        if isAttorney {
            loadAttorneyData()
        }
    }
    
    private func loadAttorneyData() {
        Task {
            do {
                let url = URL(string: "\(baseURL)/getAttorney?uid=\(authModel.userData.uid)")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let attorneyData = try JSONDecoder().decode(AttorneyData.self, from: data)
                
                DispatchQueue.main.async {
                    self.especialidad = attorneyData.especialidad
                    self.descripcion = attorneyData.descripcion
                    self.casosEjemplo = attorneyData.casosEjemplo
                }
            } catch {
                print("Failed to load attorney data: \(error)")
            }
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
                
                try await authModel.updateUserInfo(fields: ["fechaDeNacimiento": birthDateString])
                
                if isAttorney {
                    try await updateAttorneyData()
                }
                
                dismiss()
            } catch {
                errorMessage = "Failed to update profile: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
    
    private func updateAttorneyData() async throws {
        let url = URL(string: "\(baseURL)/updateAttorney")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "uid": authModel.userData.uid,
            "especialidad": especialidad,
            "descripcion": descripcion,
            "casosEjemplo": casosEjemplo
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}

struct CustomInputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isMultiline: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
                .padding(.vertical, 10)
                .alignmentGuide(.top) { _ in 0 }
            
            if isMultiline {
                TextEditor(text: $text)
                    .frame(height: 100)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.gray)
                    }
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: isMultiline ? 120 : 60)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .topLeading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 0.65 : 0)
                self
            }
        }
}

struct AttorneyData: Codable {
    let especialidad: String
    let descripcion: String
    let casosEjemplo: String
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
