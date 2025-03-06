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

class CreateEstimateViewController: UIViewController {
    
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
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var titleTextField: OptionBoxView = {
        let textField = ClearableTextField(
            editText: editTextRelay,
            isTextFieldFocused: isTextFieldFocusedRelay,
            disabled: disabled,
            placeholder: "제목을 입력하세요."
        )
        let optionBoxView = OptionBoxView(title: "제목", content: textField)
        return optionBoxView
    }()
    
    //MARK: - Properties
    private var editTextRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private var isTextFieldFocusedRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var disabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Initialize
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .matchYouBackground
        setUI()
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
        
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleTextField)
        
        navigationBarView.setBackButtonAction { [weak self] in
            self?.dismiss(animated: true)
        }
        
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
            make.top.equalTo(divider.snp.bottom).inset(-12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
            make.width.equalTo(scrollView.snp.width).offset(-24)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
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

