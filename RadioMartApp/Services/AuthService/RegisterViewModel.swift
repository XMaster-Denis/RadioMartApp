//
//  RegisterViewModel.swift
//  RadioMartApp
//
//  Created by XMaster on 06.03.2024.
//

import Foundation

@MainActor
@Observable
class RegisterViewModel {
    var email: String = ""
    var password: String = ""
    var passwordCheck: String = ""
    var showPassword: Bool = false
    var showPasswordCheck: Bool = false
    
    var isLoading: Bool = false
    var errorMessage: String = ""
    var showErrorAlert: Bool = false
    var isRegistered: Bool = false
    
    func registarionWithEmail() {
        // Reset state before starting
        errorMessage = ""
        showErrorAlert = false
        isRegistered = false

        Task {
            do {
                isLoading = true
                try validateForm()
                try await AuthManager.shared.registerWithEmail(email: email, password: password)
                AuthManager.shared.updateDisplayName(newDisplayName: email)
                await SettingsSyncManager.shared.ensureSettingsExists()

                isRegistered = true
            } catch let error as AppAuthError {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            } catch {
                errorMessage = AppAuthError.unknown.localizedDescription
                showErrorAlert = true
            }
            isLoading = false
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
