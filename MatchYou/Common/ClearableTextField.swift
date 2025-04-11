//
//  ClearableTextField.swift
//  MatchYou
//
//  Created by 김견 on 3/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ClearableTextField: UIView {
    
    //MARK: - RX
    private let disposeBag = DisposeBag()
    
    var editText: BehaviorRelay<String>
    var isTextFieldFocused: BehaviorRelay<Bool>
    var disabled: BehaviorRelay<Bool>
    
    var onlyAllowNumber: Bool = false
    
    //MARK: - View
    let textField = UITextField()
    private let clearButton = UIButton(type: .system)
    
    //MARK: - Initialize
    init(editText: BehaviorRelay<String>, isTextFieldFocused: BehaviorRelay<Bool>, disabled: BehaviorRelay<Bool>, placeholder: String? = nil, onlyAllowNumber: Bool = false) {
        self.editText = editText
        self.isTextFieldFocused = isTextFieldFocused
        self.disabled = disabled
        self.onlyAllowNumber = onlyAllowNumber
        super.init(frame: .zero)
        
        setView(placeholder: placeholder)
        setBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(placeholder: String?) {
        textField.placeholder = placeholder
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.delegate = self
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .gray
        clearButton.isHidden = true
        clearButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        clearButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [textField, clearButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        self.isUserInteractionEnabled = true
        
    }
    
    private func setBindings() {
        textField.rx.text.orEmpty
            .bind(to: editText)
            .disposed(by: disposeBag)
        
        editText
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        editText
            .map { $0.isEmpty }
            .bind(to: clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.editText.accept("")
            }
            .disposed(by: disposeBag)
        
        disabled
            .map { !$0 }
            .bind(to: textField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
}

//MARK: - UITextFieldDelegate
extension ClearableTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isTextFieldFocused.accept(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isTextFieldFocused.accept(false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if onlyAllowNumber {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
