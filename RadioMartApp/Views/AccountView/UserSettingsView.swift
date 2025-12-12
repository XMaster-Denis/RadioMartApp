//
//  UserSettingsView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI

struct UserSettingsView: View {
    @ObservedObject var authManager = AuthManager.shared

    
    var body: some View {
        
        VStack{
            Form {
                Section("string-displayName"){
                    TextField("", text: $authManager.displayName)
                }
            }
        }
    }
    
}

#Preview {
    UserSettingsView()
}
