//
//  PostUsecaseTests.swift
//  MatchYou
//
//  Created by 김견 on 2/19/25.
//

import XCTest

final class PostUsecaseTests: XCTestCase {
    var usecase: PostUseCaseProtocol!
    var repository: PostRepositoryProtocol!
    
    override func setUp() {
        super.setUp()
        repository = MockPostRepository()
        usecase = PostUseCase(repository: repository)
    }
    
    func testSavePost() {
        Task {
            let post: Post = Post(id: "1", title: "포스트", content: "내용", userId: "1", imageUrl: nil, date: Date())
            let result = await usecase.savePost(post: post)
            
        }
    }
    
    override func tearDown() {
        repository = nil
        usecase = nil
        super.tearDown()
    }
}
