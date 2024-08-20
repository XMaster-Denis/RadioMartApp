//
//  SignInViewModel.swift
//  RadioMartApp
//
//  Created by XMaster on 04.03.2024.
//

import Foundation
import Observation
import FirebaseAuth



@Observable
class SignInModel {
    var email = ""
    var password = ""
    var resetPasswordEmail = ""
    var showPassword = false
    var showRegistrationView = false
    var showResetPasswordView = false
    
    func validateSignInForm() throws {
        if !email.validatorEmail() {
            throw AppAuthError.invalidEmail
        } else if password.count < 6 {
            throw AppAuthError.invalidPasswordLength
        }
    }    
    
    func validateForgotPasswordForm() throws {
        if !resetPasswordEmail.validatorEmail() {
            throw AppAuthError.invalidEmail
        }
    }
    
    func signWithEmail() {
        Task {
            do {
                try validateSignInForm()
                try await AuthService.shared.signWithEmail(email: email, password: password)
            } catch let error as AppAuthError {
                print(error.localizedDescription)
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func resetPassword() {
        Task {
            do {
                try validateForgotPasswordForm()
                try await AuthService.shared.resetPassword(email: resetPasswordEmail)
                showResetPasswordView = false
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
}
