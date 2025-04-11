//
//  CreateEstimateViewController.swift
//  MatchYou
//
//  Created by 김견 on 3/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CreateEstimateViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - ViewModel
    private let viewModel = CreateEstimateViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - View
    private let navigationBarView = NavigationBarView()
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var titleTextField: OptionBoxView = {
        let textField = ClearableTextField(
            editText: viewModel.titleEditTextRelay,
            isTextFieldFocused: viewModel.titleIsTextFieldFocusedRelay,
            disabled: viewModel.titleDisabledRelay,
            placeholder: "작업명을 입력하세요."
        )
        let optionBoxView = OptionBoxView(title: "작업명", content: textField)
        return optionBoxView
    }()
    private lazy var clientNameTextField: OptionBoxView = {
        let textField = ClearableTextField(
            editText: viewModel.clientNameEditTextRelay,
            isTextFieldFocused: viewModel.clientNameIsTextFieldFocusedRelay,
            disabled: viewModel.clientNameDisabledRelay,
            placeholder: "고객명을 입력하세요."
        )
        let optionBoxView = OptionBoxView(title: "고객명", content: textField)
        return optionBoxView
    }()
    private lazy var descriptionTextView: OptionBoxView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .none
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        
        let containerView = UIView()
        containerView.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.edges.equalToSuperview().inset(8)
        }
        
        let optionBoxView = OptionBoxView(title: "설명", content: containerView)
        return optionBoxView
    }()
    
    private let photoPickerView: MultiPhotoPickerView = MultiPhotoPickerView()
    
    private lazy var estimatedPriceTextField: OptionBoxView = {
        let textField = ClearableTextField(
            editText: viewModel.estimatedPriceEditTextRelay,
            isTextFieldFocused: viewModel.estimatedPriceIsTextFieldFocusedRelay,
            disabled: viewModel.estimatedPriceDisabledRelay,
            placeholder: "견적 금액을 입력해주세요.",
            onlyAllowNumber: true
        )
        textField.textField.keyboardType = .numberPad
        
        let optionBoxView = OptionBoxView(title: "견적 금액", content: textField)
        return optionBoxView
    }()
    
    private let startDateField: OptionBoxView = {
        let datePickerTextField = DatePickerTextField()
        
        let optionBoxView = OptionBoxView(title: "시작 날짜", content: datePickerTextField)
        return optionBoxView
    }()
    
    private let endDateField: OptionBoxView = {
        let datePickerTextField = DatePickerTextField()
        
        let optionBoxView = OptionBoxView(title: "종료 날짜", content: datePickerTextField)
        return optionBoxView
    }()
    
    private lazy var dateField: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.addArrangedSubview(startDateField)
        stackView.addArrangedSubview(endDateField)
        
        return stackView
    }()
    
    private let bottomButtonView: BottomButtonView = BottomButtonView()
        
    //MARK: - Properties
    
    
    //MARK: - Initialize
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .matchYouBackground
        setUI()
        setAction()
        bindingViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - UI
    private func setUI() {
        view.addSubview(navigationBarView)
        view.addSubview(divider)
        view.addSubview(scrollView)
        view.addSubview(bottomButtonView)
        
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleTextField)
        contentStackView.addArrangedSubview(clientNameTextField)
        contentStackView.addArrangedSubview(descriptionTextView)
        contentStackView.addArrangedSubview(photoPickerView)
        contentStackView.addArrangedSubview(estimatedPriceTextField)
        contentStackView.addArrangedSubview(dateField)
        
        navigationBarView.setTitle("견적 작성")
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomButtonView.snp.top)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
            make.width.equalTo(scrollView.snp.width).offset(-24)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        photoPickerView.snp.makeConstraints { make in
            make.height.equalTo(68)
        }
    }
    
    //MARK: - Action
    private func setAction() {
        navigationBarView.setBackButtonAction { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Bind
    private func bindingViewModel() {
        navigationBarView.setTempSaveButtonAction { [weak self] in
            self?.viewModel.tempSaveAction.accept(())
        }
        
        bottomButtonView.onTap = { [weak self] in
            self?.viewModel.saveAction.accept(())
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

final class NavigationBarView: UIView {
    
    // MARK: - View
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "견적 작성"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let tempSaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("임시저장", for: .normal)
        button.setTitleColor(.gray.withAlphaComponent(0.5), for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func setUI() {
        let stackView = UIStackView(arrangedSubviews: [backButton, tempSaveButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        addSubview(stackView)
        addSubview(titleLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    func setBackButtonAction(_ action: @escaping () -> Void) {
        backButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
    }
    
    func setTempSaveButtonAction(_ action: @escaping () -> Void) {
        tempSaveButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

final class OptionBoxView: UIView {
    
    //MARK: - View
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let borderView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.borderColor = UIColor.matchYouSecondary.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let contentView: UIView!
    
    private var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Initialization
    init(title: String, content: UIView) {
        self.title = title
        self.contentView = content
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {
        titleLabel.text = title
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, borderView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        
        addSubview(stackView)
        
        
        borderView.addArrangedSubview(contentView)
        
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class BottomButtonView: UIView {
    var onTap: (() -> Void)?
    
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .matchYouBackground
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
        button.setBackgroundColor(.matchYouSecondary, for: .normal)
        button.setBackgroundColor(.matchYouSecondary.withAlphaComponent(0.5), for: .highlighted)
        button.tintColor = .white
        button.setTitle("작성 완료", for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
    }
    
    @objc private func handleTap(_ sender: UIButton) {
        onTap?()
    }
}

