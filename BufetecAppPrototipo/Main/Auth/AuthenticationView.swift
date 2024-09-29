import SwiftUI

struct AuthenticationView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var splashScreenState: SplashScreenState
    @StateObject private var animationViewModel = LoginAnimationViewModel()
    @State private var isShowingSignUp = false
    @State private var phoneNumber = ""
    @State private var gender = ""
    @State private var birthDate = Date()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    switch authModel.authState {
                    case .signedOut, .signingIn:
                        if isShowingSignUp {
                            SignUpView(isShowingSignUp: $isShowingSignUp)
                        } else {
                            LoginView(isShowingSignUp: $isShowingSignUp, logoPosition: $splashScreenState.logoPosition)
                                .environmentObject(animationViewModel)
                        }
                    case .needsAdditionalInfo:
                        additionalInfoView
                    case .authenticating:
                        ProgressView("Completing profile...")
                    case .authenticated:
                        CustomTabView()
                    case .needsEmailVerification:
                        EmailVerificationView()
                    }
                }
                .disabled(authModel.isLoading)
                
                if authModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            .onAppear {
                authModel.checkUserSession()
                animationViewModel.startAnimations()
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var additionalInfoView: some View {
        VStack {
            Text("Complete Your Profile")
                .font(.title)
                .padding()
            
            TextField("Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
                .padding()
            
            Picker("Gender", selection: $gender) {
                Text("Select Gender").tag("")
                Text("Male").tag("male")
                Text("Female").tag("female")
                Text("Other").tag("other")
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                .padding()
            
            Button("Complete Profile") {
                completeProfile()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(phoneNumber.isEmpty || gender.isEmpty || authModel.isLoading)
        }
        .padding()
        .disabled(authModel.isLoading)
    }
    
    private func completeProfile() {
        Task {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let birthDateString = dateFormatter.string(from: birthDate)
                try await authModel.completeUserProfile(celular: phoneNumber, genero: gender, fechaDeNacimiento: birthDateString)
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
    AuthenticationView()
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
        .environmentObject(SplashScreenState())
}
