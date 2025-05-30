//
//  AppleSignInManager.swift
//  RadioMartApp
//
//  Created by XMaster on 14.12.24.
//


import AuthenticationServices
import CryptoKit

// 1.
class AppleSignInManager {
    
    static let shared = AppleSignInManager()

    fileprivate static var currentNonce: String?

    static var nonce: String? {
        currentNonce ?? nil
    }

    private init() {
    }

    // TODO: Request Apple Authorization.
    func requestAppleAuthorization(_ request: ASAuthorizationAppleIDRequest) {
        AppleSignInManager.currentNonce = randomNonceString()
        request.requestedScopes = [] // [.fullName, .email]
        request.nonce = sha256(AppleSignInManager.currentNonce!)
    }
}

extension AppleSignInManager {
    // 2.
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    // 3. 
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
