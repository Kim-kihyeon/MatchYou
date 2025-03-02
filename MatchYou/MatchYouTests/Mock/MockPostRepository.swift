//
//  MockPostRepository.swift
//  MatchYou
//
//  Created by 김견 on 2/19/25.
//

import Foundation

public class MockPostRepository: PostRepositoryProtocol {
    public func fetchPosts(userId: String) async -> Result<[Post], NetworkError> {
        .failure(.dataNil)
    }
    
    public func savePost(post: Post) async -> Result<Void, NetworkError> {
        .failure(.dataNil)
    }
    
    public func deletePost(postId: String) async -> Result<Void, NetworkError> {
        .failure(.dataNil)
    }
    
    
}
