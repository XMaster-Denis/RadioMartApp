//
//  SignInWithAppleButtonView.swift
//  RadioMartApp
//
//  Created by XMaster on 14.12.24.
//


import SwiftUI

struct SignInWithAppleButtonView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "applelogo")
                    .font(.system(size: 20))
                Text("sign.in.with.apple:string")
                    .fontWeight(.medium)
            }
            .foregroundColor(.black)
            .padding()
            .frame(height: 50)
            .frame(minWidth: 250)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 3)
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    SignInWithAppleButtonView(){
        
    }
}
