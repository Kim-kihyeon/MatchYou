//
//  LoginViewModel.swift
//  MatchYou
//
//  Created by 김견 on 2/26/25.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

protocol LoginViewModelProtocol {
    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output
}

public final class LoginViewModel: LoginViewModelProtocol {
    private let usecase: LoginUseCase
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let user = BehaviorRelay<User?>(value: nil)
    
    public init(usecase: LoginUseCase) {
        self.usecase = usecase
    }
    
    public struct Input {
        let oAuthProviderType: Observable<OAuthProviderType>
    }
    
    public struct Output {
        let user: Observable<User?>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        let userData: Observable<User?> = input.oAuthProviderType.flatMap { [weak self] oAuthProviderType in
            
            switch oAuthProviderType {
            case .google:
                self?.signInWithGoogle()
                return self?.user.asObservable() ?? Observable.just(nil)
            case .apple:
                self?.signInWithApple()
                return self?.user.asObservable() ?? Observable.just(nil)
            }
        }
        
        return Output(user: userData, error: error.asObservable())
    }
    
    func signInWithGoogle()  {
        Task {
            let result = await usecase.signInWithGoogle()
            
            switch result {
            case .success(let user):
                self.user.accept(user)
                
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
    func signInWithApple()  {
        Task {
            let result = await usecase.signInWithApple()
            
            switch result {
            case .success(let user):
                self.user.accept(user)
                
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
}

enum OAuthProviderType {
    case google
    case apple
}
