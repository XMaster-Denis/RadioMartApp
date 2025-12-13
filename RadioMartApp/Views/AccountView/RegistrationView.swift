//
//  RegistrationView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI


struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var regViewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("register.account:string")
                    .bold()
                    .font(.title2)
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
                                .foregroundStyle(.white)
                        }
                }
                
            }
            
            
            SignInFieldView(placeHolder: "email.address:string".l, text: $regViewModel.email)
            
            SignInSecureFieldView(placeHolder: "your.password:string".l, showPassword: $regViewModel.showPassword, text: $regViewModel.password)
            
            SignInSecureFieldView(placeHolder: "repeat.password:string".l, showPassword: $regViewModel.showPasswordCheck, text: $regViewModel.passwordCheck)
            
            if !regViewModel.errorMessage.isEmpty {
                Text(regViewModel.errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
            
            Button{
                regViewModel.registarionWithEmail()
            } label: {
                HStack(spacing: 10) {
                    if regViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                    
                    Text("register:string")
                        .font(.title3)
                        .bold()
                }
                .foregroundStyle(.white)
                .padding()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange)
                }
            }
            .disabled(regViewModel.isLoading)

            Spacer()
        }
        .onChange(of: regViewModel.isRegistered, { oldValue, newValue in
            if newValue {
                dismiss()
            }
        })
        .padding()
        .background(Color("baseBlue"))
        .alert(
            "registration.error.title:string",
            isPresented: $regViewModel.showErrorAlert
        ) {
            Button("Ok") {
                if regViewModel.isRegistered {
                    dismiss()
                }
            }
        } message: {
                Text(regViewModel.errorMessage)
        }
    }
}

#Preview {
    RegistrationView()
}
