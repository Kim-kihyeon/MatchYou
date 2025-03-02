//
//  LoginUseCaseProtocol.swift
//  MatchYou
//
//  Created by 김견 on 2/26/25.
//

import Foundation
import FirebaseAuth

public protocol LoginUseCaseProtocol {
    func signInWithGoogle() async -> Result<User, NetworkError>
    func signInWithApple() async -> Result<User, NetworkError>
}

public struct LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
    
    public func signInWithGoogle() async -> Result<User, NetworkError> {
        await repository.signInWithGoogle()
    }
    
    public func signInWithApple() async -> Result<User, NetworkError> {
        await repository.signInWithApple()
    }
}
