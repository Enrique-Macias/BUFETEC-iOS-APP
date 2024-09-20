import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        FirebaseApp.configure()
        return true
    }
}


struct RegisterView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @Environment(\.colorScheme) var colorScheme
    @State private var date = Date()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("btBackground")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    // Main title
                    Text("Registro")
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                        .foregroundStyle(.primary)
                        .padding(.bottom, 22)
                    
                    // Name Field
                    HStack {
                        Image(systemName: "person")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        TextField("Donathan Smith", text: $name)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        TextField("Correo electrónico", text: $email)
                            .keyboardType(.emailAddress)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Phone Field
                    HStack {
                        Image(systemName: "phone")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        TextField("Teléfono", text: $phone)
                            .keyboardType(.phonePad)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        SecureField("Contraseña", text: $password)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Confirm Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        SecureField("Confirmar contraseña", text: $confirmPassword)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Date picker
                    HStack {
                        Text("Fecha de nacimiento")
                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        .frame(width: 140, height: 0)
                    }
                    .padding()
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Register Button using NavigationLink
                    NavigationLink(destination: DocumentValidationView()) {
                        Text("Registrarse")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .frame(maxWidth: 340, minHeight: 55)
                            .background(colorScheme == .light ? Color.black : Color.white)
                            .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    //Spacer()
                    //Sing up with google
                    HStack{
                        
                        Image("googleicon")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Registrarse con Google")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .frame(maxWidth: 340, minHeight: 55)
                            .background(colorScheme == .light ? Color.white: Color.black)
                            .foregroundColor(colorScheme == .light ? Color.mint : Color.black)
                            .cornerRadius(8)
                    }
                    .padding()
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("btIcon")
                    .resizable()
                    .foregroundStyle(colorScheme == .light ? Color.accentColor : .white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
        }
    }
}

#Preview {
    RegisterView()
        .environment(AppearanceManager())
}
