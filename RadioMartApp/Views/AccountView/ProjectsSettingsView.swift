//
//  AccountView 2.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.24.
//


//
//  AccountView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI

struct ProjectsSettingsView: View {
//    @ObservedObject var userFB = UserSettingsFireBaseViewModel.shared
    @ObservedObject var settingsManager = SettingsManager.shared
    @ObservedObject var authManager = AuthManager.shared

    @State private var showAuthForm: Bool = false
    
    var body: some View {
        
        VStack{
            Form {
                Section("your.company.name:string"){
                    TextField("", text: settingsManager.companyName)
                }
            }
        }
    }
    
}

#Preview {
    UserSettingsView()
}
