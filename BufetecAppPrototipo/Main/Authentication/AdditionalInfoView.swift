import SwiftUI

struct AdditionalInfoView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    @State private var phoneNumber = ""
    @State private var gender: String?
    @State private var birthDate = Date()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    private var isCompleteProfileDisabled: Bool {
        phoneNumber.isEmpty || gender == nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("btBackground")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Completa tu perfil")
                            .font(CustomFonts.MontserratBold(size: 25))
                            .foregroundStyle(.primary)
                        
                        VStack(spacing: 15) {
                            InputField(icon: "phone", placeholder: "Teléfono", text: $phoneNumber)
                                .keyboardType(.phonePad)
                            
                            genderPicker
                            birthdatePicker
                        }
                        .padding(.horizontal)
                        
                        completeProfileButton
                    }
                    .padding()
                }
                .disabled(authModel.isLoading)
                .overlay(loadingOverlay)
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var genderPicker: some View {
        Menu {
            Button("Masculino") { gender = "Masculino" }
            Button("Femenino") { gender = "Femenino" }
            Button("Otro") { gender = "Otro" }
        } label: {
            HStack {
                Image(systemName: "person")
                Text(gender ?? "Género")
                Spacer()
                Image(systemName: "chevron.down")
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
    }
    
    private var birthdatePicker: some View {
        HStack {
            Image(systemName: "calendar")
            Text("Fecha de nacimiento")
            Spacer()
            DatePicker("", selection: $birthDate, displayedComponents: [.date])
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
    
    private var completeProfileButton: some View {
        Button(action: completeProfile) {
            Text("Completar Perfil")
                .font(CustomFonts.MontserratBold(size: 16))
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                .background(isCompleteProfileDisabled ? Color.gray : (colorScheme == .light ? Color.black : Color.white))
                .cornerRadius(16)
        }
        .disabled(isCompleteProfileDisabled || authModel.isLoading)
    }
    
    private var loadingOverlay: some View {
        Group {
            if authModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            }
        }
    }
    
    private func completeProfile() {
        Task {
            do {
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                try await authModel.completeUserProfile(celular: phoneNumber, genero: gender ?? "", fechaDeNacimiento: dateFormatter.string(from: birthDate))
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    AdditionalInfoView()
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
}
