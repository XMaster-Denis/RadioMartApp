//
//  ContentView.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var projectSyncManager = ProjectSyncManager.shared
    
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
        
        .alert("Объединить локальные проекты с облаком?", isPresented: $projectSyncManager.showMergePrompt) {
            Button("Да") {
                projectSyncManager.pendingSyncContinuation?.resume(returning: true)
                projectSyncManager.pendingSyncContinuation = nil
            }
            Button("Нет", role: .cancel) {
                projectSyncManager.pendingSyncContinuation?.resume(returning: false)
                projectSyncManager.pendingSyncContinuation = nil
            }
        }
        
    }
    

}

#Preview {
    ContentView()
}
