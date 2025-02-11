//
//  PostUseCaseProtocol.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation

public protocol PostUseCaseProtocol {
    func fetchPosts() async -> Result<[Post], NetworkError>
    func savePost(post: Post) -> Result<Void, NetworkError>
    func deletePost(id: String) -> Result<Void, NetworkError>
}

public struct PostUseCase: PostUseCaseProtocol {
    public func fetchPosts() async -> Result<[Post], NetworkError> {
        <#code#>
    }
    
    public func savePost(post: Post) -> Result<Void, NetworkError> {
        <#code#>
    }
    
    public func deletePost(id: String) -> Result<Void, NetworkError> {
        <#code#>
    }
    

}
