//
//  SignInWithGoogleButtonView 2.swift
//  RadioMartApp
//
//  Created by XMaster on 25.01.25.
//
import SwiftUI

struct SignInEmailView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "envelope.badge.person.crop")
                   // .resizable()
                    //.frame(width: 20)
                Text("sign.in.with.e.mail:string")
                   
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
