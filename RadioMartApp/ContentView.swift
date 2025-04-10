//
//  ContentView.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        ZStack {
            Rectangle()
                
         //   LaunchScreenView()
            GeneralTabView()
                .zIndex(0.9)
        }
        .task {
            print(AuthManager.shared.authState)
//            if authManager.authState == .signedOut {
//                authManager.signAnonymously()
//            }
        }
    }
    

}

#Preview {
    ContentView()
}
