//
//  SignInWithAppleButtonView.swift
//  RadioMartApp
//
//  Created by XMaster on 14.12.24.
//


import SwiftUI
import AuthenticationServices


struct CustomAppleButton: View {
//    var label: String
    var onRequest: (ASAuthorizationAppleIDRequest) -> Void
    var onCompletion: (Result<ASAuthorization, Error>) -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // 1) Ваша стилизация
            
            // 2) Невидимая нативная кнопка
      
            
            
            HStack {
                Image(systemName: "applelogo")
                Text("label")
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(width: 250, height: 50)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(colorScheme == .dark ? .white : .gray, lineWidth: 1))
            .allowsHitTesting(false)
            
            
            SignInWithAppleButton(
                onRequest: onRequest,
                onCompletion: onCompletion
            )
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .opacity(0.01)
            .contentShape(Rectangle())      // весь прямоугольник кликабелен
            .allowsHitTesting(true)

            .frame(width: 250, height: 50)
     
        }
        .frame(width: 250, height: 50)
    }
}

//struct SignInWithAppleButtonView: View {
//    @Environment(\.colorScheme) private var colorScheme
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 8) {
//                Image(systemName: "applelogo")
//                    .font(.system(size: 20, weight: .medium))
//                Text("sign.in.with.apple:string")
//                    .fontWeight(.medium)
//            }
//            .padding(.horizontal, 16)
//            .frame(height: 50)
//            .frame(minWidth: 250)
//            // Динамический фон: в светлой теме systemBackground = белый, в тёмной — почти чёрный
//            .background(Color(.systemBackground))
//            // Текст и иконка в системный label (чёрный в светлой/белый в тёмной)
//            .foregroundColor(Color(.label))
//            // Обводка системным separator
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color(.separator), lineWidth: 3)
//            )
//            .cornerRadius(10)
//            // Немного тени, чтобы было «повыше» на светлом фоне
//            .shadow(color: Color(.black).opacity(colorScheme == .light ? 0.1 : 0),
//                    radius: 4, x: 0, y: 2)
//        }
//    }
//}
//
//#Preview {
//    Group {
//        SignInWithAppleButtonView { print("Tapped") }
//            .padding()
////            .previewLayout(.sizeThatFits)
////            .preferredColorScheme(.light)
//
//        SignInWithAppleButtonView { print("Tapped") }
//            .padding()
////            .previewLayout(.sizeThatFits)
////            .preferredColorScheme(.dark)
//    }
//}
