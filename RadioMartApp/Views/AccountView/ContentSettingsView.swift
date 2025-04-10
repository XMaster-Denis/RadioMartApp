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

struct ContentSettingsView: View {
    @ObservedObject var userFB = UserSettingsFireBaseViewModel.shared
    @ObservedObject var authManager = AuthManager.shared

    @State private var showAuthForm: Bool = false
    
    var body: some View {
        
        VStack{
            Form {
                Section("string-content"){
                    Picker("string-content.language", selection: $userFB.settings.contentLanguage){
                        ForEach(ContentLanguages.allCases, id: \.self) {item in
                            Text(item.rawValue)
                        }
                    }
                }
            }
            Button("save:string") {
            }
        }
    }
    
}

#Preview {
    UserSettingsView()
}
