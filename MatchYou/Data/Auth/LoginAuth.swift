//
//  LoginAuth.swift
//  MatchYou
//
//  Created by 김견 on 2/26/25.
//

import Foundation
import Supabase

public protocol LoginAuthProtocol {
    func signInWithGoogle() async -> Result<User, NetworkError>
    func signInWithApple() async -> Result<User, NetworkError>
}

final public class LoginAuth: LoginAuthProtocol {
    private let manager: AuthManagerProtocol
    
    init(manager: AuthManagerProtocol) {
        self.manager = manager
    }
    
    public func signInWithGoogle() async -> Result<User, NetworkError> {
        await manager.signInWithGoogle()
    }
    
    public func signInWithApple() async -> Result<User, NetworkError> {
        await manager.signInWithApple()
    }
}
