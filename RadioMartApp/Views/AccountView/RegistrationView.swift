//
//  RegistrationView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI


struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @State var regViewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Register Account")
                    .bold()
                    .font(.largeTitle)
                    .padding(.leading)
                Spacer()
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .bold()
                        .imageScale(.large)
                        .foregroundStyle(.red)
                        .background {
                            Circle()
                        }
                }
                
            }
            
            
            SignInFieldView(placeHolder: "Email Address", text: $regViewModel.email)
            
            SignInSecureFieldView(placeHolder: "Your Password", showPassword: $regViewModel.showPassword, text: $regViewModel.password)
            
            SignInSecureFieldView(placeHolder: "Repeat Password", showPassword: $regViewModel.showPasswordCheck, text: $regViewModel.passwordCheck)
            Button{
                regViewModel.registarionWithEmail()
            } label: {
                
                Text("Register")
                    .font(.title)
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
        }
        .padding()
        .background(Color("baseBlue"))
    }
}

#Preview {
    RegistrationView()
}


