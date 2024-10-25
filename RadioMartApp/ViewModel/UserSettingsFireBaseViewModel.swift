//
//  SettingsFireBaseViewModel.swift
//  RadioMartApp
//
//  Created by XMaster on 20.08.2024.
//

import Foundation
import Combine

import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserSettingsFireBaseViewModel: ObservableObject {
  @Published var settings = UserSettingsFireBase.empty

  @Published private var user: User?
  private var db = Firestore.firestore()
  private var cancellables = Set<AnyCancellable>()

  init() {
    registerAuthStateHandler()

    $user
      .compactMap { $0 }
      .sink { user in
        self.settings.userId = user.uid
      }
      .store(in: &cancellables)
  }

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.fetchSettings()
      }
    }
  }

  func fetchSettings() {
    guard let uid = user?.uid else { return }
    Task {
      do {
        self.settings  = try await db.collection("user_settings").document(uid).getDocument(as: UserSettingsFireBase.self)
      }
      catch {
        print(error.localizedDescription)
      }
    }
  }

  func saveSettings() {
    guard let documentId = user?.uid else { return }

    do {
      try db.collection("user_settings").document(documentId).setData(from: settings)
    }
    catch {
      print(error.localizedDescription)
    }
  }
    
    func updateDisplayName(newDisplayName: String) {
        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = newDisplayName
            changeRequest.commitChanges { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("No user is currently signed in.")
        }
    }
}
