//
//  SignInWithGoogleButtonView 2.swift
//  RadioMartApp
//
//  Created by XMaster on 25.01.25.
//
import SwiftUI

struct SignInEmailView: View {
    @Environment(\.colorScheme) private var colorScheme
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "envelope.badge.person.crop")
                Text("sign.in.with.e.mail:string")
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
