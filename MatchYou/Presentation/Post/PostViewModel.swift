//
//  PostViewModel.swift
//  MatchYou
//
//  Created by 김견 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol PostViewModelProtocol {
    
}

public final class PostViewModel: PostViewModelProtocol {
    private let usecase: PostUseCaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchPostList = BehaviorRelay<[Post]>(value: [])
    private var page: Int = 0
    
    public init(usecase: PostUseCaseProtocol) {
        self.usecase = usecase
    }
    
    public struct Input {
        let tabButtonType: Observable<TabButtonType>
        let userId: Observable<String>
        let savePost: Observable<Post>
        let deletePost: Observable<String>
        let fetchMore: Observable<Void>
    }
    
    public struct Output {
        let cellData: Observable<[PostCellData]>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        input.userId.bind { [weak self] userId in
            guard let self else { return }
            self.page = 0
            self.fetchPost(userId: userId, page: self.page)
        }.disposed(by: disposeBag)
        
        input.savePost.bind { [weak self] post in
            self?.savePost(post: post)
        }.disposed(by: disposeBag)
        
        input.deletePost.bind { [weak self] postId in
            self?.deletePost(postId: postId)
        }.disposed(by: disposeBag)
        
        input.fetchMore
            .withLatestFrom(input.userId)
            .bind { [weak self] userId in
                guard let self else { return }
                self.page += 1
                self.fetchPost(userId: userId, page: page)
        }.disposed(by: disposeBag)
        
        let cellData: Observable<[PostCellData]> = Observable.combineLatest(input.tabButtonType, fetchPostList).map { [weak self] tabButtonType, fetchPostList in
            let cellData: [PostCellData] = []
            guard let self else { return cellData }
            
            switch tabButtonType {
            case .api:
                let postCellList = fetchPostList.map { post in
                    PostCellData.post(post: post)
                }
                return postCellList
            }
        }
        
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func fetchPost(userId: String, page: Int) {
        Task {
            let result = await usecase.fetchPosts(userId: userId, page: page, pageSize: 10)
            
            switch result {
            case .success(let posts):
                if fetchPostList.value.isEmpty {
                    fetchPostList.accept(posts)
                } else {
                    fetchPostList.accept(fetchPostList.value + posts)
                }
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func savePost(post: Post) {
        Task {
            let result = await usecase.savePost(post: post)
            
            switch result {
            case .success():
                print("Success to save post")
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func deletePost(postId: String) {
        Task {
            let result = await usecase.deletePost(postId: postId)
            
            switch result {
                case .success():
                print("Success to delete post")
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
}

public enum TabButtonType {
    case api
}

public enum PostCellData {
    case post(post: Post)
}
