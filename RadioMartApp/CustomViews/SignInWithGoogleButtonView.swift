//
//  SignInWithGoogleButtonView.swift
//  RadioMartApp
//
//  Created by XMaster on 14.12.24.
//


import SwiftUI

struct SignInWithGoogleButtonView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image("google_button")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("sign.in.with.google:string")
                   
                    .font(.system(size: 19, weight: .medium, design: .default))
            }
            .foregroundColor(.black)
            .padding()
            .frame(height: 50)
            .frame(minWidth: 250)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
            )

        }
    }
}

#Preview {
    SignInWithGoogleButtonView(){
        
    }
}
