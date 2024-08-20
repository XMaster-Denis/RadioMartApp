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

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
//        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        
        return true
    }
}


@main
struct RadioMartAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DataBase.shared.modelContainer)
        .environment(\.locale, Locale(identifier: "ru"))
    }
}
