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

enum AppAuthError: String, LocalizedError {
    case invalidEmail = "msg: invalidEmail"
    case invalidPasswordLength = "msg: invalidPasswordLength"
    case passwordsDoNotMatch = "msg: passwordsDoNotMatch"
    
    case emailAlreadyInUse = "msg: emailAlreadyInUse"
    case wrongPassword = "msg: wrongPassword"
    case tooManyRequests = "msg: tooManyRequests"
    case networkError = "msg: networkError"
    
    var errorDescription: String? {
        self.rawValue
    }
}


@Observable
final class AuthService {
    
    var currentUser: FirebaseAuth.User?
    
    private let auth = Auth.auth()
    static let shared = AuthService()
    
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
