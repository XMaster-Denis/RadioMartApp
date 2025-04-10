//
//  ForgotPasswordView.swift
//  RadioMartApp
//
//  Created by XMaster on 06.03.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: SignInModel
    
    var body: some View {
        VStack {
            HStack {
                Text("reset.password:string")
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
                       
                }
                
            }
            SignInFieldView(placeHolder: "please.enter.your.email:string", text: $viewModel.resetPasswordEmail)
            Button {
                viewModel.resetPassword()
            } label: {
                Text("reset.password:string")
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

        }
        .padding()
    }
}

#Preview {
    ForgotPasswordView(viewModel: .init())
}
