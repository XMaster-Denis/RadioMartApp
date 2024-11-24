//
//  RadioMartAppApp.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseFirestore
import FirebaseInAppMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        setenv("GRPC_DNS_RESOLVER", "native", 1)
        setenv("GRPC_ARG_ADDRESS_FAMILY", "4", 1) // Использовать только IPv4
//        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        FirebaseApp.configure()
  //      let db = Firestore.firestore()
//        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        
        return true
    }
}


@main
struct RadioMartAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var userSettingsFireBase: UserSettingsFireBaseViewModel = UserSettingsFireBaseViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettingsFireBase)
        }
        .modelContainer(DataBase.shared.modelContainer)
        .environment(\.locale, Locale(identifier: "ru"))
    }
}
