//
//  GeneralSettingsMenuView.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.24.
//

import SwiftUI

struct GeneralSettingsMenuView: View {
    
//    @ObservedObject var userFB = UserSettingsFireBaseViewModel.shared
    
//    @ObservedObject var settingsManager = SettingsManager.shared
    
    @ObservedObject var authManager = AuthManager.shared
    
    @State private var showAuthForm: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                NavigationLink { UserSettingsView() } label: {
                    MenuSettingsItem(image: "person", title: "user:string", description: "username.and.account.settings:string")
                }
                Divider()
                NavigationLink { ContentSettingsView() } label: {
                    MenuSettingsItem(image: "doc.plaintext", title: "content:string", description: "translation.settings:string")
                }
                Divider()
                NavigationLink { ProjectsSettingsView() } label: {
                    MenuSettingsItem(image: "shippingbox", title: "projects:string", description: "company.settings:string")
                }
                Divider()

                Spacer()
//                Button("to firabase") {
//                    Task {
//                        await SettingsSyncManager.shared.saveSettings()
//                        
//                    }
//                }
            }
            .navigationTitle("settings:string")
            .padding()
            
            
            HStack {
                Text("account: :string")
                if AuthManager.shared.authState == .signedIn {
                    Text(AuthManager.shared.displayName)
                    
                    Button(action: { signOut() }) {
                        Text("sign.out:string")
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                                    .stroke(.blue, lineWidth: 2)
                            }
                    }
                } else {
                    Button(action: { showAuthForm.toggle() }) {
                        Text("sign.in:string")
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                                    .stroke(.blue, lineWidth: 2)
                            }
                    }
//                    NavigationLink("Sign in", destination: SignInView())
                }
            }
            .sheet(isPresented: $showAuthForm) {
                SignInView()
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await AuthManager.shared.signOut()
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}

struct MenuSettingsItem: View {
    let image: String
    let title: LocalizedStringKey  // LocalizedStringKey
    let description: LocalizedStringKey
    var body: some View {
        HStack {
            Image(systemName: image)
                .font(.system(size: 25))
                .frame(width: 25)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .bold()
                Text(description)
                    .font(.caption)
            }
        }
    }
}


#Preview {
    GeneralSettingsMenuView()
}
