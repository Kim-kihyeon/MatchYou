//
//  PostRepositoryProtocol.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation

public protocol PostRepositoryProtocol {
    func fetchPosts(userId: String, page: Int, pageSize: Int) async -> Result<[Post], NetworkError>
    func savePost(post: Post) async -> Result<Void, NetworkError>
    func deletePost(postId: String) async -> Result<Void, NetworkError>
}
