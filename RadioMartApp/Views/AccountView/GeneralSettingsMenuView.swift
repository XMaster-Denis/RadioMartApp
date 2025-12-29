//
//  GeneralSettingsMenuView.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.24.
//

import SwiftUI

struct GeneralSettingsMenuView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.locale) var locale
    @State private var showAuthForm: Bool = false
    @State private var showDeleteConfirm = false
    @State private var showDeleteError = false
    @State private var deleteErrorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                NavigationLink {
                    UserSettingsView()
                } label: {
                    MenuSettingsItem(
                        image: "person",
                        title: "user:string",
                        description: "username.and.account.settings:string")
                }
                
                Divider()
                
                NavigationLink { ContentSettingsView()
                } label: {
                    MenuSettingsItem(
                        image: "doc.plaintext",
                        title: "content:string",
                        description: "translation.settings:string")
                }
                
                Divider()
                
                NavigationLink {
                    ProjectsSettingsView()
                } label: {
                    MenuSettingsItem(
                        image: "shippingbox",
                        title: "projects:string",
                        description: "company.settings:string")
                }
                
                Divider()

                Spacer()
            }
            .navigationTitle("settings:string")
            .padding()
            
            
            HStack {
                
                if AuthManager.shared.authState == .signedIn {
                    VStack {
                        HStack {
                            Text("account: :string")
                            Text(AuthManager.shared.displayName)

                            Button(action: { signOut() }) {
                                Text("sign.out:string")
                                    .padding(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                            .stroke(.blue, lineWidth: 2)
                                    }
                            }
                        }
                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            Text("delete.account:string")
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                        .stroke(.red, lineWidth: 2)
                                }
                        }
                        
                    }
                    


                } else {
                    Button(action: { showAuthForm.toggle() }) {
                        Text("sign.in:string")
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                                    .stroke(.blue, lineWidth: 2)
                            }
                    }
                }
            }
            .sheet(isPresented: $showAuthForm) {
                SignInView()
            }
            .alert("delete.account.title:string".l, isPresented: $showDeleteConfirm) {
                Button("cancel:string".l, role: .cancel) {}
                Button("delete:string".l, role: .destructive) {
                    Task {
                        do {
                            try await AuthManager.shared.deleteAccount()
                        } catch let error as AppAuthError {
                            deleteErrorMessage = error.localizedDescription
                            showDeleteError = true
                        } catch {
                            deleteErrorMessage = AppAuthError.unknown.localizedDescription
                            showDeleteError = true
                        }
                    }
                }
            } message: {
                Text("delete.account.message:string".l)
            }
            .alert("delete.account.error.title:string".l, isPresented: $showDeleteError) {
                Button("ok:string".l, role: .cancel) {}
            } message: {
                Text(deleteErrorMessage)
            }
        }
        .id(locale.identifier)
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
    let title: LocalizedStringKey
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}


#Preview {
    GeneralSettingsMenuView()
}
