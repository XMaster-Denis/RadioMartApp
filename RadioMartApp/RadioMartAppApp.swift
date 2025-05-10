//
//  RadioMartAppApp.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023.
//

import SwiftUI
import SwiftData

import FirebaseCore
import FirebaseAppCheck

import FirebaseInstallations



class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        Installations.installations().installationID { id, error in
            if let error = error {
                print("Ошибка получения Installation ID: \(error)")
            } else if let id = id {
                print("Installation ID: \(id)")
            }
        }
        
        return true
    }
}


@main
struct RadioMartAppApp: App {
  
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var localizationManager = LM.shared
    
    init() {

        
//    #if DEBUG
//        let providerFactory = AppCheckDebugProviderFactory()
//        AppCheck.setAppCheckProviderFactory(providerFactory)
//    #endif

        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localizationManager)
                .environment(\.locale, Locale(identifier: localizationManager.currentLanguage.code))
                .environmentObject(SettingsManager.shared.currentProjectViewModel)
        }
        .modelContainer(DataBase.shared.modelContainer)
    }
}
