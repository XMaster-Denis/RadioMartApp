//
//  AccountView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI

struct ContentSettingsView: View {
    @ObservedObject var settingsManager = SettingsManager.shared
    
    var body: some View {
        
        VStack{
            Form {
                Section("string-content"){
                    Picker("string-content.language", selection: settingsManager.contentLanguage){
                        ForEach(ContentLanguages.allCases, id: \.self) {item in
                            Text(item.rawValue)
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    UserSettingsView()
}
