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
    var errorMessage: String = ""
    
    
    
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
    
    func signWithEmail(complection: @escaping (Bool, AppAuthError?) -> Void) {
        Task {
            do {
                try validateSignInForm()
                try await AuthManager.shared.signWithEmail(email: email, password: password)
                complection(true, nil)
            } catch let error as AppAuthError {
                print(error.localizedDescription)
                complection(false, error)
            } catch {
                print(error.localizedDescription)
                complection(false, AppAuthError.unknown)
            }
            
        }
    }
    

    
    func resetPassword() {
        Task {
            do {
                try validateForgotPasswordForm()
                try await AuthManager.shared.resetPassword(email: resetPasswordEmail)
                showResetPasswordView = false
            } catch let error as AppAuthError {
                self.errorMessage = error.localizedDescription
            } catch {
                self.errorMessage = AppAuthError.unknown.localizedDescription
            }
            
        }
    }
    
}
