//
//  RegisterViewModel.swift
//  RadioMartApp
//
//  Created by XMaster on 06.03.2024.
//

import Foundation

@Observable
class RegisterViewModel {
    var email: String = ""
    var password: String = ""
    var passwordCheck: String = ""
    var showPassword: Bool = false
    var showPasswordCheck: Bool = false
    
    func registarionWithEmail() {
        Task {
            do {
                try validateForm()
                try await AuthManager.shared.registerWithEmail(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func validateForm() throws {
        if !email.validatorEmail() {
            throw AppAuthError.invalidEmail
        } else if password.count < 6 || passwordCheck.count < 6 {
            throw AppAuthError.invalidPasswordLength
        } else if password != passwordCheck {
            throw AppAuthError.passwordsDoNotMatch
        }
    }
}
