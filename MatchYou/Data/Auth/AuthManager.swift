//
//  AuthManager.swift
//  MatchYou
//
//  Created by 김견 on 2/25/25.
//

import CryptoKit
import AuthenticationServices
import Supabase
import GoogleSignIn

protocol AuthManagerProtocol {
    func signInWithGoogle() async -> Result<User, NetworkError>
    func signInWithApple() async -> Result<User, NetworkError>
    func signOut() -> Result<Void, NetworkError>
}

public class AuthManager: NSObject, AuthManagerProtocol {
    fileprivate var currentNonce: String?
    private var appleSignInContinuation: CheckedContinuation<Result<User, NetworkError>, Never>?
    
    func signInWithGoogle() async -> Result<User, NetworkError> {
        //        do {
        //            let redirectURL = "https://dbgjrsekvactprfysgqf.supabase.co/auth/v1/callback"
        //            let session = try await SupabaseService.shared.client.auth.signInWithOAuth(provider: .google, redirectTo: URL(string: redirectURL))
        //            let user = session.user
        //
        //            return .success(user)
        //        } catch {
        //            return .failure(.requestFailed(error.localizedDescription))
        //        }
        
        
        
        guard let rootViewController = await (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?
            .rootViewController else {
            return .failure(.dataNil)
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                print("idToken is nil")
                return .failure(.dataNil)
            }
            
            let accessToken = result.user.accessToken.tokenString
            let nonce = randomNonceString()
            
            self.currentNonce = nonce
            
            let session = try await SupabaseService.shared.client.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .google,
                    idToken: idToken,
                    accessToken: accessToken
                )
            )
            let user = session.user
            
            return .success(user)
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
            
//        do {
//            let user: User = try await withCheckedThrowingContinuation { continuation in
//                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
//                    if let error {
//                        continuation.resume(throwing: error)
//                        return
//                    }
//                    
//                    guard let authentication = signInResult?.user, let idToken = authentication.idToken else {
//                        continuation.resume(throwing: NetworkError.requestFailed("Failed to Google Sign In"))
//                        return
//                    }
//                    
//                    let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)
//                    
//                    Auth.auth().signIn(with: credential) { result, error in
//                        if let error {
//                            continuation.resume(throwing: error)
//                        } else if let user = result?.user {
//                            continuation.resume(returning: user)
//                        }
//                    }
//                }
//            }
//            return .success(user)
//        } catch {
//            return .failure(.requestFailed(error.localizedDescription))
//        }
    }
    
    func signInWithApple() async -> Result<User, NetworkError> {
        let nonce = randomNonceString()
        self.currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        return await withCheckedContinuation { continuation in
            self.appleSignInContinuation = continuation
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    func signOut() -> Result<Void, NetworkError> {
        .failure(.invalid)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate random bytes. SecRandomCopyBytes failed with error \(errorCode).")
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashString
    }
}

extension AuthManager: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    appleSignInContinuation?.resume(returning: .failure(.dataNil))
                    return
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    appleSignInContinuation?.resume(returning: .failure(.dataNil))
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    appleSignInContinuation?.resume(returning: .failure(.dataNil))
                    return
                }
                
                let credential = OpenIDConnectCredentials(
                    provider: .apple,
                    idToken: idTokenString,
                    nonce: nonce
                )
                                
                do {
                    let session = try await SupabaseService.shared.client.auth.signInWithIdToken(credentials: credential)
                    
                    let user = session.user
                    appleSignInContinuation?.resume(returning: .success(user))
                } catch {
                    appleSignInContinuation?.resume(returning: .failure(.requestFailed("Apple Sign In 실패: \(error.localizedDescription)")))
                }
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        appleSignInContinuation?.resume(returning: .failure(.requestFailed("Apple ID 로그인 실패")))
    }
}

extension AuthManager: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?
            .rootViewController else {
            fatalError("rootViewController를 찾을 수 없습니다.")
        }
        return rootViewController.view.window ?? ASPresentationAnchor()
    }
}
