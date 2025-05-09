////
////  SettingsFireBaseViewModel.swift
////  RadioMartApp
////
////  Created by XMaster on 20.08.2024.
////
//
//import Foundation
//import Combine
//
//import FirebaseAuth
//import FirebaseFirestore
//
//
//class UserSettingsFireBaseViewModel_old: ObservableObject {
//    
//    static let shared = UserSettingsFireBaseViewModel_old()
//    
//    @Published var settings =  UserSettingsFireBase.empty
//    
//    @Published private var user: User?
//    let db = FirebaseManager.shared.db
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        registerAuthStateHandler()
//        
//        $user
//            .compactMap { $0 }
//            .sink { user in
//                self.settings.userId = user.uid
//            }
//            .store(in: &cancellables)
//    }
//    
//    private var authStateHandler: AuthStateDidChangeListenerHandle?
//    
//    func registerAuthStateHandler() {
//        if authStateHandler == nil {
//            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
//                self.user = user
//                self.fetchSettings()
//            }
//        }
//    }
//    
//    func fetchSettings() {
//        guard let uid = user?.uid else { return }
//        Task {
//            do {
//                let fetchedSettings = try await db.collection("user_settings").document(uid).getDocument(as: UserSettingsFireBase.self)
//                await MainActor.run {
//                    self.settings = fetchedSettings
//                }
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func saveSettings() {
//        guard let documentId = user?.uid else { return }
//        
//        do {
//            try db.collection("user_settings").document(documentId).setData(from: settings)
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//
//}
