//
//  ContentView.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023..
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var projectSyncManager = ProjectSyncManager.shared
    
    var body: some View {
        ZStack {
            Rectangle()
#if !DEBUG
            LaunchScreenView()
#endif
            GeneralTabView()
                .zIndex(0.9)
            
        }
        .task {
            print(AuthManager.shared.authState)
//            if authManager.authState == .signedOut {
//                authManager.signAnonymously()
//            }
        }
        
        .alert("sync.merge.prompt:string", isPresented: $projectSyncManager.showMergePrompt) {
            Button("sync.merge.yes:string") {
                projectSyncManager.pendingSyncContinuation?.resume(returning: true)
                projectSyncManager.pendingSyncContinuation = nil
            }
            Button("sync.merge.no:string", role: .cancel) {
                projectSyncManager.pendingSyncContinuation?.resume(returning: false)
                projectSyncManager.pendingSyncContinuation = nil
            }
        }
        
    }
    

}

#Preview {
    ContentView()
}
