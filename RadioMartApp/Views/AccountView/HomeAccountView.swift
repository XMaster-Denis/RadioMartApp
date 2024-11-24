//
//  HomeAccountView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI
import SwiftOpenAI

struct HomeAccountView: View {
    @ObservedObject var userFB = UserSettingsFireBaseViewModel.shared
    
    @State var displayName: String = AuthService.shared.currentUser?.displayName ?? "User"
    @State var responce: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section("string-settings"){
                    Picker("string-content.language", selection: $userFB.settings.contentLanguage){
                        ForEach(ContentLanguages.allCases, id: \.self) {item in
                            Text(item.rawValue)
                        }
                    }
                }
                Section("string-displayName"){
                    TextField("", text: $displayName)
                }
                Section("string-yourCompanyName"){
                    TextField("", text: $userFB.settings.yourCompanyName)
                }
                
            }
            
            
            
            
            Text(responce)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(5)
                .lineSpacing(1.0)
            
       
            Button("save") {
                userFB.updateDisplayName(newDisplayName: displayName)
                userFB.saveSettings()
            }
            .buttonStyle(.borderedProminent)
            

            
            Text("Hello, \(displayName)!")
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
