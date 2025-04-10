//
//  AuthService.swift
//  RadioMartApp
//
//  Created by XMaster on 04.03.2024.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseCore
//import FirebaseFirestore
import FirebaseAuth

//enum AppAuthError: String, LocalizedError {
//    case invalidEmail = "Invalid email. Check and try again."
//    case invalidPasswordLength = "Password too short (min 6 chars)."
//    case passwordsDoNotMatch = "Passwords don't match."
//    case emailAlreadyInUse = "Email already in use. Log in instead."
//    case wrongPassword = "Wrong password. Try again."
//    case tooManyRequests = "Too many attempts. Try later."
//    case networkError = "Network error. Check connection."
//    
//    var errorDescription: String? {
//        self.rawValue
//    }
//}


@Observable
final class AuthService2 {
    
    var currentUser: FirebaseAuth.User?
    
    private let auth = Auth.auth()
    static let shared = AuthService2()
    
    private init() {
        currentUser = auth.currentUser
    }
    
    func registerWithEmail(email: String, password: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            currentUser = result.user
        } catch {
            if let nsError = error as NSError? {
                        let errorCode = AuthErrorCode(rawValue: nsError.code)
                        switch errorCode {
                        case .emailAlreadyInUse:
                            throw AppAuthError.emailAlreadyInUse
                        case .invalidEmail:
                            throw AppAuthError.invalidEmail
                        case .wrongPassword:
                            throw AppAuthError.wrongPassword
                        case .tooManyRequests:
                            throw AppAuthError.tooManyRequests
                        case .networkError:
                            throw AppAuthError.networkError
                        default:
                            throw AppAuthError.networkError
                        }
                    } else {
                        throw AppAuthError.networkError
                    }
        }
    }
        
    func signWithEmail(email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            currentUser = result.user
        } catch {
            if let nsError = error as NSError? {
                        let errorCode = AuthErrorCode(rawValue: nsError.code)
                        switch errorCode {
                        case .emailAlreadyInUse:
                            throw AppAuthError.emailAlreadyInUse
                        case .invalidEmail:
                            throw AppAuthError.invalidEmail
                        case .wrongPassword:
                            throw AppAuthError.wrongPassword
                        case .tooManyRequests:
                            throw AppAuthError.tooManyRequests
                        case .networkError:
                            throw AppAuthError.networkError
                        default:
                            throw AppAuthError.networkError
                        }
                    } else {
                        throw AppAuthError.networkError
                    }
        }
    }
    
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
    }
    
    
}
