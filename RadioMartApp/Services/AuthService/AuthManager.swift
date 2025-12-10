//
//  AuthManager.swift
//  RadioMartApp
//
//  Created by XMaster on 14.12.24.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

enum AuthState {

    case signedIn
    case signedOut
}

enum AppAuthError: String, LocalizedError {
    case invalidEmail = "Invalid email. Check and try again."
    case invalidPasswordLength = "Password too short (min 6 chars)."
    case passwordsDoNotMatch = "Passwords don't match."
    case emailAlreadyInUse = "Email already in use. Log in instead."
    case wrongPassword = "Wrong password. Try again."
    case tooManyRequests = "Too many attempts. Try later."
    case networkError = "Network error. Check connection."
    
    var errorDescription: String? {
        self.rawValue
    }
}

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    
    @Published var user: User?
    @Published var authState = AuthState.signedOut
    @Published var displayName = "User"
    
    var userId: String? {
        user?.uid
    }
    
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    init() {
        configureAuthStateChanges()

        if let user = Auth.auth().currentUser {
            updateState(user: user)
        }
    }


    func configureAuthStateChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
            self.updateState(user: user)
        }
    }
    

    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }


    func updateState(user: User?) {
        self.user = user
        let isAuthenticatedUser = user != nil
        if isAuthenticatedUser {
            self.authState = .signedIn
            Task {
                await ProjectSyncManager.shared.syncProjectsBetweenLocalAndCloud()
                ProjectSyncManager.shared.startAutoSync()
                
                await SettingsSyncManager.shared.fetchSettings()
                SettingsSyncManager.shared.startSettingsAutoSync()
            }
            
            displayName = getDisplayName()
        } else {
            self.authState = .signedOut
            ProjectSyncManager.shared.stopAutoSync()
            SettingsSyncManager.shared.stopSettingsAutoSync()
            
        }
    }
    
    func signOut() async throws {
        self.user = nil
        if let _ = Auth.auth().currentUser {
            do {
                // TODO: Sign out from signed-in Provider.
                try Auth.auth().signOut()
                ProjectSyncManager.shared.stopAutoSync()
                SettingsSyncManager.shared.stopSettingsAutoSync()
                
            }
            catch let error as NSError {
                print("FirebaseAuthError: failed to sign out from Firebase, \(error)")
                throw error
            }
        }
        print("restart")
        ProjectsManager.shared.restart()
    }
    
    func getDisplayName() -> String {
        guard let user else { return "User" }
        return user.displayName ?? "***"
    }
    
    func updateDisplayName(newDisplayName: String) {
        if let user = user {
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
    
    func registerWithEmail(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            user = result.user
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
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            user = result.user
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
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    

    

    private func authenticateUser(credentials: AuthCredential) async throws -> AuthDataResult? {
        if Auth.auth().currentUser != nil {
            return try await authLink(credentials: credentials)
        } else {
            return try await authSignIn(credentials: credentials)
        }
    }


    private func authSignIn(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().signIn(with: credentials)
            updateState(user: result.user)
            return result
        }
        catch {
            print("FirebaseAuthError: signIn(with:) failed. \(error)")
            throw error
        }
    }

   
    private func authLink(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            guard let user = Auth.auth().currentUser else { return nil }
            let result = try await user.link(with: credentials)
            // TODO: Update user's displayName
            updateState(user: result.user)
            return result
        }
        catch {
            print("FirebaseAuthError: link(with:) failed, \(error)")
            throw error
        }
    }
    
    func googleAuth(_ user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else { return nil }
        
     
        let credentials = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
        )
        do {
           
            return try await authenticateUser(credentials: credentials)
        }
        catch {
            print("FirebaseAuthError: googleAuth(user:) failed. \(error)")
            throw error
        }
    }
    
    
    func appleAuth(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        nonce: String?
    ) async throws -> AuthDataResult? {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }

        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return nil
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return nil
        }

      
        let credentials = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)

        do { 
            return try await authenticateUser(credentials: credentials)
        }
        catch {
            print("FirebaseAuthError: appleAuth(appleIDCredential:nonce:) failed. \(error)")
            throw error
        }
    }
}
