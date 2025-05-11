//
//  GoogleSignInManager.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.24.
//


import GoogleSignIn

class GoogleSignInManager {

    static let shared = GoogleSignInManager()

    typealias GoogleAuthResult = (GIDGoogleUser?, Error?) -> Void

    private init() {}

    @MainActor 
    func signInWithGoogle() async throws -> GIDGoogleUser? {
       
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            return try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        } else {
           
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return nil }

            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            return result.user
        }
    }
    
   
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
