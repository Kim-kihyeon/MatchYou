//
//  CreateEstimateViewController.swift
//  MatchYou
//
//  Created by 김견 on 3/5/25.
//

import UIKit
import SnapKit
import RxSwift

class CreateEstimateViewController: UIViewController {
    
    //MARK: - View
    private let navigationBarView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        return stackView
    }()
    
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
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private func setUI() {
        navigationBarView.addArrangedSubview(backButton)
        navigationBarView.addArrangedSubview(tempSaveButton)
        
        backButton.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        
        view.addSubview(navigationBarView)
        view.addSubview(titleLabel)
        view.addSubview(divider)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(navigationBarView)
            make.centerY.equalTo(navigationBarView)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc private func handleBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
