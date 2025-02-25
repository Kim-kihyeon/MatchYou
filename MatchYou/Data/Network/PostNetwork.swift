//
//  PostNetwork.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation

public protocol PostNetworkProtocol {
    func fetchPosts(userId: String) async -> Result<[Post], NetworkError>
    func savePost(post: Post) async -> Result<Void, NetworkError>
    func deletePost(postId: String) async -> Result<Void, NetworkError>
}

final public class PostNetwork: PostNetworkProtocol {
    private let manager: NetworkManagerProtocol
    private let tableName: String = "posts"
    
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    public func fetchPosts(userId: String) async -> Result<[Post], NetworkError> {
        await manager.fetchData(table: tableName, id: userId)
    }
    
    public func savePost(post: Post) async -> Result<Void, NetworkError> {
        await manager.saveData(table: tableName, data: post)
    }
    
    public func deletePost(postId: String) async -> Result<Void, NetworkError> {
        await manager.deleteData(table: tableName, dataId: postId)
    }
}
