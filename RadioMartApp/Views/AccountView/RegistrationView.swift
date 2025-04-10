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
                Text("register.account:string")
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
            
            
            SignInFieldView(placeHolder: "email.address:string", text: $regViewModel.email)
            
            SignInSecureFieldView(placeHolder: "your.password:string", showPassword: $regViewModel.showPassword, text: $regViewModel.password)
            
            SignInSecureFieldView(placeHolder: "repeat.password:string", showPassword: $regViewModel.showPasswordCheck, text: $regViewModel.passwordCheck)
            Button{
                regViewModel.registarionWithEmail()
            } label: {
                
                Text("register:string")
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


