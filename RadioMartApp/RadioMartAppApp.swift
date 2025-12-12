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

import Kingfisher



class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
//        Installations.installations().installationID { id, error in
//            if let error = error {
//                print("Ошибка получения Installation ID: \(error)")
//            } else if let id = id {
//                print("Installation ID: \(id)")
//            }
//        }
        
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
        KingfisherManager.shared.downloader.sessionConfiguration.httpMaximumConnectionsPerHost = 4
        KingfisherManager.shared.downloader.downloadTimeout = 20
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .id(localizationManager.currentLanguage.code) // force full UI refresh when app language changes
                .environmentObject(localizationManager)
                .environment(\.locale, Locale(identifier: localizationManager.currentLanguage.code))
                .environmentObject(SettingsManager.shared)
                .environmentObject(ProjectsManager.shared)
        }
        .modelContainer(DataBase.shared.modelContainer)
    }
}
