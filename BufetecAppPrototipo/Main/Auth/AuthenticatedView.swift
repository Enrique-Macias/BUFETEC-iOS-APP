import SwiftUI

struct AuthenticatedView: View {
    @EnvironmentObject var authModel: AuthModel
    @State private var isEditingProfile = false
    @State private var editedNombre = ""
    @State private var editedCelular = ""
    @State private var editedGenero = ""
    @State private var editedFechaDeNacimiento = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    if isEditingProfile {
                        TextField("Nombre", text: $editedNombre)
                        TextField("Celular", text: $editedCelular)
                            .keyboardType(.phonePad)
                        Picker("Género", selection: $editedGenero) {
                            Text("Male").tag("male")
                            Text("Female").tag("female")
                            Text("Other").tag("other")
                        }
                        DatePicker("Fecha de Nacimiento", selection: $editedFechaDeNacimiento, displayedComponents: .date)
                    } else {
                        LabeledContent("Nombre", value: authModel.userData.nombre)
                        LabeledContent("Email", value: authModel.userData.email)
                        LabeledContent("Celular", value: authModel.userData.celular)
                        LabeledContent("Género", value: authModel.userData.genero)
                        LabeledContent("Fecha de Nacimiento", value: authModel.userData.fechaDeNacimiento)
                        LabeledContent("Tipo", value: authModel.userData.tipo)
                    }
                }
                
                Section {
                    if isEditingProfile {
                        Button("Save Changes") {
                            saveChanges()
                        }
                        .disabled(editedNombre.isEmpty || editedCelular.isEmpty || editedGenero.isEmpty)
                    } else {
                        Button("Edit Profile") {
                            startEditing()
                        }
                    }
                }
                
                Section {
                    Button("Sign Out") {
                        Task {
                            await authModel.logout()
                        }
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Welcome, \(authModel.userData.nombre)!")
            .toolbar {
                if isEditingProfile {
                    Button("Cancel") {
                        cancelEditing()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func startEditing() {
        editedNombre = authModel.userData.nombre
        editedCelular = authModel.userData.celular
        editedGenero = authModel.userData.genero
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: authModel.userData.fechaDeNacimiento) {
            editedFechaDeNacimiento = date
        }
        isEditingProfile = true
    }
    
    private func cancelEditing() {
        isEditingProfile = false
    }
    
    private func saveChanges() {
        Task {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let birthDateString = dateFormatter.string(from: editedFechaDeNacimiento)
                
                try await authModel.updateUserInfo(newData: [
                    "nombre": editedNombre,
                    "celular": editedCelular,
                    "genero": editedGenero,
                    "fechaDeNacimiento": birthDateString
                ])
                await MainActor.run {
                    isEditingProfile = false
                }
            } catch {
                await MainActor.run {
                    showingAlert = true
                    alertMessage = "Failed to update profile: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    AuthenticatedView()
        .environmentObject(AuthModel())
}
