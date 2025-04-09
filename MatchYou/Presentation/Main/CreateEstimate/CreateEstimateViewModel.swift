//
//  CreateEstimateViewModel.swift
//  MatchYou
//
//  Created by 김견 on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol CreateEstimateViewModelProtocol {
    
}

public final class CreateEstimateViewModel: CreateEstimateViewModelProtocol {
    // MARK: - Input
    let titleEditTextRelay = BehaviorRelay<String>(value: "")
    let titleIsTextFieldFocusedRelay = BehaviorRelay<Bool>(value: false)
    let titleDisabledRelay = BehaviorRelay<Bool>(value: false)
    
    let clientNameEditTextRelay = BehaviorRelay<String>(value: "")
    let clientNameIsTextFieldFocusedRelay = BehaviorRelay<Bool>(value: false)
    let clientNameDisabledRelay = BehaviorRelay<Bool>(value: false)
    
    let descriptionTextRelay = BehaviorRelay<String>(value: "")
    
    let tempSaveAction = PublishRelay<Void>()
    let saveAction = PublishRelay<Void>()
    
    // MARK: - Output
    let isValid = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    init() {
        Observable.combineLatest(titleEditTextRelay, clientNameEditTextRelay, descriptionTextRelay)
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
            .bind(to: isValid)
            .disposed(by: disposeBag)
        
        saveAction
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
            })
            .disposed(by: disposeBag)
        
        tempSaveAction
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
            })
            .disposed(by: disposeBag)
    }
}
