//
//  LoginRepository.swift
//  MatchYou
//
//  Created by 김견 on 2/26/25.
//

import Foundation
import Supabase

public struct LoginRepository: LoginRepositoryProtocol {
    private let network: LoginAuthProtocol
    
    init(network: LoginAuthProtocol) {
        self.network = network
    }
    
    public func signInWithGoogle() async -> Result<User, NetworkError> {
        await network.signInWithGoogle()
    }
    
    public func signInWithApple() async -> Result<User, NetworkError> {
        await network.signInWithApple()
    }
}
