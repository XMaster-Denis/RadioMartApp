//
//  HomeAccountView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI
import SwiftOpenAI

//struct HomeAccountView: View {
//    
//    @EnvironmentObject var authManager: AuthManager
//    @State var responce: String = ""
//    
//    var body: some View {
//        VStack {
//
//            Text(responce)
//                .foregroundColor(.primary)
//                .multilineTextAlignment(.leading)
//                .lineLimit(5)
//                .lineSpacing(1.0)
//            
//       
//
//            Text("Hello, \(authManager.getDisplayName())!")
//            Button(role: .destructive) {
//                do {
//                    try AuthService.shared.signOut()
//                    
//                } catch {
//                    print(error.localizedDescription)
//                }
//            } label: {
//                Text("SignOut")
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 30)
//                            .fill(.yellow)
//                            .stroke(.red, lineWidth: 2)
//                    }
//            }
//        }
//
//    }
//}
//
//#Preview {
//    HomeAccountView()
//}
