//
//  PostNetwork.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation

final public class PostNetwork {
    private let manager: NetworkManagerProtocol
    private let tableName: String = "posts"
    
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    func fetchPosts() async -> Result<[Post], NetworkError> {
        await manager.fetchData(table: tableName)
    }
}
