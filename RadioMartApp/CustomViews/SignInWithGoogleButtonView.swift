//
//  SignInWithGoogleButtonView.swift
//  RadioMartApp
//
//  Created by XMaster on 14.12.24.
//


import SwiftUI

struct SignInWithGoogleButtonView: View {
    @Environment(\.colorScheme) private var colorScheme
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
            .padding()
            .frame(height: 50)
            .frame(minWidth: 250)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.6) : Color.gray, lineWidth: 3)
            )
            .cornerRadius(10)
            .shadow(color: Color(.black).opacity(colorScheme == .light ? 0.1 : 0), radius: 4, x: 0, y: 2)

        }
    }
}

#Preview {
    SignInWithGoogleButtonView(){
        
    }
}
