import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseCore


struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @State var signInModel = SignInModel()
    @ObservedObject var authManager =  AuthManager.shared
    @State private var showSignInForm = false
    @ObservedObject var projectSyncManager = ProjectSyncManager.shared
    
    var body: some View {
        
        VStack {
  
            Image("imag16")
                .resizable()
                .scaledToFill()
                .overlay(content: {
                    LinearGradient(colors: [.white, .clear], startPoint: .bottom, endPoint: .top)
                })
                .frame(height: 300)
            
            VStack(spacing: 6) {

                SignInWithAppleButton(
                    onRequest: { request in
                        AppleSignInManager.shared.requestAppleAuthorization(request)
                    },
                    onCompletion: { result in
                        handleAppleID(result)
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(width: 250, height: 50, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                
                
                SignInWithGoogleButtonView {
                    print("Sign in with Google tapped")
                    Task{
                        await signInWithGoogle()
                    }
                }
                
                SignInEmailView {
                    withAnimation {
                        showSignInForm.toggle()
                    }
                }
                
                
                
            }
            

            if showSignInForm {
                VStack {

                    HStack {
                        Spacer()
                        Button("User 1") {
                            signInModel.email = "user1@test.com"
                            signInModel.password = "123123"
                        }
                        Spacer()
                        Button("User 2") {
                            signInModel.email = "user2@test.com"
                            signInModel.password = "123123"
                        }
                        Spacer()
                        Button("User 3") {
                            signInModel.email = "user3@test.com"
                            signInModel.password = "123123"
                        }
                        Spacer()
                    }
                    
                    SignInFieldView(placeHolder: "email:string", text: $signInModel.email)
                    SignInSecureFieldView(placeHolder: "password:string", showPassword: $signInModel.showPassword, text: $signInModel.password)
                    Button("forgot.password:string") {
                        signInModel.showResetPasswordView = true
                    }
                    .bold()
                    
                    Button {
                        signInModel.signWithEmail(){ success, error in
                            if success {
                                dismiss()
                            } else {
                                if let error = error {
                                    signInModel.errorMessage = error.localizedDescription
                                } else {
                                    signInModel.errorMessage = "invalid.email.or.password.please.try.again.:string"
                                }
                            }
                        }
                    } label: {
                        Text("sign.in:string")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.orange)
                            }
                    }
                    if signInModel.errorMessage != "" {
                        Text(signInModel.errorMessage)
                    }
                    
                    Spacer()
                    Text("dont.have.an.account.yet?:string")
                    
                    Button {
                        signInModel.showRegistrationView = true
                    } label: {
                        Text("register:string")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.orange)
                            }
                    }
                    
                    
                }
                .padding()
                .padding(.bottom, 75)
            }
            
            Spacer()
        }
        .ignoresSafeArea()
        
        .sheet(isPresented: $signInModel.showRegistrationView) {
            RegistrationView()
                .presentationDetents([.fraction(0.5)])
        }
        
        .sheet(isPresented: $signInModel.showResetPasswordView, content: {
            ForgotPasswordView(viewModel: signInModel)
                .presentationDetents([.fraction(0.4)])
        })
        

    }

    
    func signInWithGoogle() async {
        do {
            guard let user = try await GoogleSignInManager.shared.signInWithGoogle() else { return }
            
            let result = try await authManager.googleAuth(user)
            if let result = result {
                print("GoogleSignInSuccess: \(result.user.uid)")
                dismiss()
            }
        }
        catch {
            print("GoogleSignInError: failed to sign in with Google, \(error))")
            // Here you can show error message to user.
        }
    }
    
    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }
            
            Task {
                do {
                    let result = try await authManager.appleAuth(
                        appleIDCredentials,
                        nonce: AppleSignInManager.nonce
                    )
                    if result != nil {
                        dismiss()
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                    // Here you can show error message to user.
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // Here you can show error message to user.
        }
    }
    
}


