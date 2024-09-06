import SwiftUI

struct LoginView: View {
    let logoAnimationDelay: Double = 1.5
    let logoAnimationDuration: Double = 0.4
    let contentAnimationDuration: Double = 0.2
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @Environment(\.colorScheme) var colorScheme
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showLogin = false
    @State private var isContentViewPresented = false
    @State private var showContent = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case username, password
    }
    
    var body: some View {
        if isContentViewPresented {
            ContentView()
                .transition(.opacity)
        } else {
            NavigationStack {
                ZStack {
                    Color("btBackground")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("LogoBufetec")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screen.width * 0.5, height: screen.width * (showLogin ? 0.3 : 0.5))
                            .padding(.top, showLogin ? 50 : -40)
                            .foregroundStyle(.primary)
                            .animation(.spring(duration: logoAnimationDuration), value: showLogin)
                        
                        if showLogin {
                            VStack {
                                Spacer()
                                Image("bye")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 270)
                                    .padding(.bottom, 30)
                                Text("Iniciar sesión con correo")
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.bottom, 20)
                                
                                Button {
                                    focusedField = .username
                                } label: {
                                    Image(systemName: "envelope")
                                    TextField("", text: $username, prompt: Text("Usuario").foregroundStyle(.gray).kerning(0))
                                        .kerning(0.8)
                                        .fontWeight(.bold)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .keyboardType(.emailAddress)
                                        .multilineTextAlignment(.leading)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(18)
                                .frame(width: screen.width * 0.9, height: 60, alignment: .leading)
                                .background(colorScheme == .dark ? Color.clear : Color.white)
                                .cornerRadius(16)
                                .foregroundStyle(.primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                                )
                                .opacity(showContent ? 1 : 0)
                                .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                                .focused($focusedField, equals: .username)
                                
                                ZStack {
                                    Button(action: { focusedField = .password }) {
                                        HStack {
                                            Image(systemName: "lock")
                                            if showPassword {
                                                TextField("", text: $password, prompt: Text("Contraseña").foregroundStyle(.gray).kerning(0))
                                                    .autocapitalization(.none)
                                                    .disableAutocorrection(true)
                                                    .kerning(0.8)
                                                    .fontWeight(.bold)
                                                    .focused($focusedField, equals: .password)
                                                    .multilineTextAlignment(.leading)
                                            } else {
                                                SecureField("", text: $password, prompt: Text("Contraseña").foregroundStyle(.gray).kerning(0))
                                                    .autocapitalization(.none)
                                                    .disableAutocorrection(true)
                                                    .kerning(0.8)
                                                    .fontWeight(.bold)
                                                    .focused($focusedField, equals: .password)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                            
                                            Button(action: {
                                                showPassword.toggle()
                                            }) {
                                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(.primary)
                                                    .opacity(0.5)
                                            }
                                            .padding(.trailing, 6)
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(18)
                                .frame(width: screen.width * 0.9, height: 60, alignment: .leading)
                                .background(colorScheme == .dark ? Color.clear : Color.white)
                                .cornerRadius(16)
                                .foregroundStyle(.primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                                )
                                .padding(.top, 10)
                                .opacity(showContent ? 1 : 0)
                                .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                                Spacer()
                                
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        isContentViewPresented = true
                                    }
                                }) {
                                    ZStack {
                                        Text("Iniciar Sesión")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                    }
                                    .frame(width: screen.width * 0.9, height: 60)
                                    .background(colorScheme == .light ? Color.black : Color.white)
                                    .cornerRadius(16)
                                    .padding(.bottom, 10)
                                }
                                .opacity(showContent ? 1 : 0)
                                .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                                Button(action: {
                                    
                                }) {
                                    Text("Recuperar Contraseña")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 14))
                                        .underline()
                                }
                                .padding(.top, 5)
                                //
                                HStack {
                                    Text("No tienes una cuenta?")
                                        .font(.system(size: 18, weight: .light))
                                        .foregroundColor(.primary.opacity(0.5))
                                    
                                    NavigationLink(destination: RegisterView()) {
                                        Text("Regístrate")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding(.bottom, 50)
                                .padding(.top, 10)
                                .opacity(showContent ? 1 : 0)
                                .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                                
                            }
                        }
                    }
                    .frame(width: screen.width, height: screen.height)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + logoAnimationDelay) {
                    withAnimation(.spring(duration: logoAnimationDuration)) {
                        showLogin = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + logoAnimationDuration) {
                        withAnimation(.easeIn(duration: contentAnimationDuration)) {
                            showContent = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AppearanceManager())
}

let screen = UIScreen.main.bounds
