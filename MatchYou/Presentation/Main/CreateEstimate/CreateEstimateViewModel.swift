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
    let titleEditTextRelay = BehaviorRelay<String>(value: "")
    let clientNameEditTextRelay = BehaviorRelay<String>(value: "")
    let descriptionTextRelay = BehaviorRelay<String>(value: "")
    
    let titleIsTextFieldFocusedRelay = BehaviorRelay<Bool>(value: false)
    let clientNameIsTextFieldFocusedRelay = BehaviorRelay<Bool>(value: false)
    
    let titleDisabledRelay = BehaviorRelay<Bool>(value: false)
    let clientNameDisabledRelay = BehaviorRelay<Bool>(value: false)
    
    let tempSaveAction = PublishRelay<Void>()
    let saveAction = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    init () {
        tempSaveAction
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        saveAction
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
    }
}
