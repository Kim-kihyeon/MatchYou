//
//  PostUseCaseProtocol.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation

public protocol PostUseCaseProtocol {
    func fetchPosts(userId: String, page: Int, pageSize: Int) async -> Result<[Post], NetworkError>
    func savePost(post: Post) async -> Result<Void, NetworkError>
    func deletePost(postId: String) async -> Result<Void, NetworkError>
}

public struct PostUseCase: PostUseCaseProtocol {
    private let repository: PostRepositoryProtocol
    
    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchPosts(userId: String, page: Int, pageSize: Int) async -> Result<[Post], NetworkError> {
        await repository.fetchPosts(userId: userId, page: page, pageSize: pageSize)
    }
    
    public func savePost(post: Post) async -> Result<Void, NetworkError> {
        await repository.savePost(post: post)
    }
    
    public func deletePost(postId: String) async -> Result<Void, NetworkError> {
        await repository.deletePost(postId: postId)
    }
    

}
