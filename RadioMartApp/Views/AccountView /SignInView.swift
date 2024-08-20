import SwiftUI


struct SignInView: View {
    @StateObject var settings = DataBase.shared.getSettings()
    @State var signInModel = SignInModel()
    
    @State var b = false
    
    var body: some View {
        
        VStack {
            //PDFGeneratorFromFlowView()
            Image("imag16")
                .resizable()
                .scaledToFill()
                .overlay(content: {
                    LinearGradient(colors: [.white, .clear], startPoint: .bottom, endPoint: .top)
                })
                .frame(height: 300)
              
            Spacer()
            VStack {
                
                Button("To complete the fields") {
                    signInModel.email = "test@test.com"
                    signInModel.password = "123123"
                }
                
                SignInFieldView(placeHolder: "Email", text: $signInModel.email)
                SignInSecureFieldView(placeHolder: "Password", showPassword: $signInModel.showPassword, text: $signInModel.password)
                Button("Forgot Password") {
                    signInModel.showResetPasswordView = true
                }
                .bold()
                
                Button {
                    signInModel.signWithEmail()
                } label: {
                    Text("Sign In")
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
                Spacer()
                Text("Dob't have an account yet?")
                
                Button {
                    signInModel.showRegistrationView = true
                } label: {
                    Text("Register")
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
        .ignoresSafeArea()
        .sheet(isPresented: $signInModel.showRegistrationView) {
            RegistrationView()
                .presentationDetents([.fraction(0.5)])
        }
        .sheet(isPresented: $signInModel.showResetPasswordView, content: {
            ForgotPasswordView(viewModel: signInModel)
                .presentationDetents([.fraction(0.4)])
        })
       // .frame(maxHeight: .infinity, alignment: .top)
      //  .ignoresSafeArea()
    }
}

#Preview {
    AccountView()
}

