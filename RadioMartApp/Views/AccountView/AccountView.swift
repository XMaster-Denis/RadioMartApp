////
////  AccountView.swift
////  RadioMartApp
////
////  Created by XMaster on 05.03.2024.
////
//
//import SwiftUI
//
//struct AccountView11: View {
//    @ObservedObject var userFB = UserSettingsFireBaseViewModel.shared
//    @ObservedObject var authManager = AuthManager.shared
////    @State var displayName: String = AuthService.shared.currentUser?.displayName ?? "User"
////    @EnvironmentObject var authManager: AuthManager
//    
//    @State private var showAuthForm: Bool = false
//    
//    var body: some View {
//        
//        VStack{
//            //            ScrollView(.vertical){
//            Form {
//                Section("settings:string"){
//                    Picker("string-content.language", selection: $userFB.settings.contentLanguage){
//                        ForEach(ContentLanguages.allCases, id: \.self) {item in
//                            Text(item.rawValue)
//                        }
//                    }
//                }
//                Section("display.name:string"){
//                    TextField("", text: $authManager.displayName)
//                }
//                Section("your.company.name:string"){
//                    TextField("", text: $userFB.settings.yourCompanyName)
//                }
//                
//            }
//            //            }
//
//            
//        }
//        
//        
//        //            Button("save") {
//        //                userFB.updateDisplayName(newDisplayName: displayName)
//        //                userFB.saveSettings()
//        //            }
//        //            .buttonStyle(.borderedProminent)
//        
//        
//        
//        //            if AuthService.shared.currentUser != nil {
//        //                       HomeAccountView()
//        //                   } else {
//        //                       SignInView()
//        //                   }
//        
//        
//        
//        
//        
//    }
//    
//
//    
//}
