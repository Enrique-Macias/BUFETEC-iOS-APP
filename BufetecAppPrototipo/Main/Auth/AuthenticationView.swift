import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authModel: AuthModel
    @State private var isShowingSignUp = false
    @State private var phoneNumber = ""
    @State private var gender = ""
    @State private var birthDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                switch authModel.authState {
                case .signedOut:
                    if isShowingSignUp {
                        SignUpView(isShowingSignUp: $isShowingSignUp)
                    } else {
                        LoginView(isShowingSignUp: $isShowingSignUp)
                    }
                case .signingIn:
                    ProgressView("Signing in...")
                case .needsAdditionalInfo:
                    VStack {
                        Text("Complete Your Profile")
                            .font(.title)
                            .padding()
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding()
                        
                        Picker("Gender", selection: $gender) {
                            Text("Male").tag("male")
                            Text("Female").tag("female")
                            Text("Other").tag("other")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                            .padding()
                        
                        Button("Complete Profile") {
                            Task {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                let birthDateString = dateFormatter.string(from: birthDate)
                                await authModel.completeUserProfile(celular: phoneNumber, genero: gender, fechaDeNacimiento: birthDateString)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(phoneNumber.isEmpty || gender.isEmpty)
                    }
                    .padding()
                case .authenticating:
                    ProgressView("Completing profile...")
                case .authenticated:
                    AuthenticatedView()
                case .needsEmailVerification:
                    EmailVerificationView()
                case .error(let message):
                    VStack {
                        Text("An error occurred")
                            .font(.title)
                            .foregroundColor(.red)
                        
                        Text(message)
                            .foregroundColor(.red)
                            .padding()
                        
                        Button("Try Again") {
                            authModel.authState = .signedOut
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .onAppear {
                authModel.checkUserSession()
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthModel())
}
