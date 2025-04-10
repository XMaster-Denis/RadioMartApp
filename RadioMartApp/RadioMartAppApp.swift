//
//  RadioMartAppApp.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023.
//

import SwiftUI
import SwiftData
//import Firebase
//import FirebaseFirestore
//import FirebaseInAppMessaging
//import FirebaseMessaging
//import FirebaseAppCheck
import FirebaseCore

//class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
//  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
//    return AppAttestProvider(app: app)
//  }
//}
import FirebaseInstallations



class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        let providerFactory: AppCheckProviderFactory
//        providerFactory = AppCheckDebugProviderFactory()
//        providerFactory = MyAppCheckProviderFactory()

//        setenv("GRPC_DNS_RESOLVER", "native", 1)
//        setenv("GRPC_ARG_ADDRESS_FAMILY", "4", 1) // Использовать только IPv4
        //        FirebaseConfiguration.shared.setLoggerLevel(.debug)
//        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        
        Installations.installations().installationID { id, error in
            if let error = error {
                print("Ошибка получения Installation ID: \(error)")
            } else if let id = id {
                print("Installation ID: \(id)")
            }
        }
        
//        Messaging.messaging().delegate = self
//        
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//            //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//          }
//        }
        
        return true
    }
}


@main
struct RadioMartAppApp: App {
  
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var userSettingsFireBase: UserSettingsFireBaseViewModel = UserSettingsFireBaseViewModel.shared
//    @StateObject var authManager: AuthManager
    
    init() {

        FirebaseApp.configure()
        // 2. Initialize authManager.
//        let authManager = AuthManager()
//        _authManager = StateObject(wrappedValue: authManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettingsFireBase)
//                .environmentObject(authManager)
                .environment(\.locale, Locale(identifier: userSettingsFireBase.settings.contentLanguage.code))
        }
        .modelContainer(DataBase.shared.modelContainer)
    }
}
