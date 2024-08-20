//
//  HomeAccountView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI

struct HomeAccountView: View {
    var body: some View {
        VStack {
            
            Text("Hello, 123!")
            Button(role: .destructive) {
                do {
                    try AuthService.shared.signOut()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text("SignOut")
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.yellow)
                            .stroke(.red, lineWidth: 2)
                    }
            }
        }

    }
}

#Preview {
    HomeAccountView()
}
