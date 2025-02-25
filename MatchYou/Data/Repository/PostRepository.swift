//
//  PostRepository.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation

public struct PostRepository: PostRepositoryProtocol {
    private let network: PostNetworkProtocol
    
    init(network: PostNetworkProtocol) {
        self.network = network
    }
    
    public func fetchPosts(userId: String) async -> Result<[Post], NetworkError> {
        await network.fetchPosts(userId: userId)
    }
    
    public func savePost(post: Post) async -> Result<Void, NetworkError> {
        await network.savePost(post: post)
    }
    
    public func deletePost(postId: String) async -> Result<Void, NetworkError> {
        await network.deletePost(postId: postId)
    }
    
    
}
