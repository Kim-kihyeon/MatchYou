//
//  LoginRepositoryProtocol.swift
//  MatchYou
//
//  Created by 김견 on 2/26/25.
//

import Foundation
import Supabase

public protocol LoginRepositoryProtocol {
    func signInWithGoogle() async -> Result<User, NetworkError>
    func signInWithApple() async -> Result<User, NetworkError>
}
