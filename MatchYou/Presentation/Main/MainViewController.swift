//
//  MainViewController.swift
//  MatchYou
//
//  Created by 김견 on 3/2/25.
//

import UIKit
import SnapKit
import Supabase

class MainViewController: UIViewController {
    //MARK: - Data
    private let user: User
    
    //MARK: - Child ViewController
    private let homeViewController = UINavigationController(rootViewController: HomeViewController())
    private let chattingViewController = ChattingViewController()
    private let createEstimateViewController = CreateEstimateViewController()
    private let myInfoViewController = MyInfoViewController()
    
    private var viewControllers: [UIViewController] = []
    
    //MARK: - View
    private let contentView = UIView()
    private let tabBarView = CustomTabBar()
    
    //MARK: - Initialize
    init(user: User) {
        self.user = user
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
        setViewControllers()
        setLayout()
        setTabBarActions()
    }
    
    private func setViewControllers() {
        viewControllers = [homeViewController, chattingViewController, UIViewController(), myInfoViewController]
        
        for viewController in viewControllers {
            addChild(viewController)
            contentView.addSubview(viewController.view)
            viewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
            viewController.didMove(toParent: self)
            viewController.view.isHidden = true
        }
        
        viewControllers.first?.view.isHidden = false
    }
    
    private func setLayout() {
        view.addSubview(contentView)
        view.addSubview(tabBarView)
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBarView.snp.top)
        }
        
        tabBarView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            
        }
    }
    
    private func setTabBarActions() {
        tabBarView.onTabSelected = { [weak self] index in
            self?.switchToTab(index: index)
        }
    }
    
    private func switchToTab(index: Int) {
        if index != 2 {
            for (i, viewController) in viewControllers.enumerated() {
                viewController.view.isHidden = i != index
            }
        } else {
            createEstimateViewController.modalPresentationStyle = .fullScreen
            createEstimateViewController.modalTransitionStyle = .coverVertical
            present(createEstimateViewController, animated: true)
        }
    }
}

final class CustomTabBar: UIView {
    var onTabSelected: ((Int) -> Void)?
    
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    
    private let tabImages: [String] = [
        "house.fill",
        "message.fill",
        "text.badge.plus",
        "person.fill"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        setBackgroundView()
        setButtons()
    }
    
    private func setBackgroundView() {
        backgroundColor = .matchYouDeep
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 5
        
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setButtons() {
        for (index, image) in tabImages.enumerated() {
            let button = UIButton()
            button.setImage(UIImage(systemName: image), for: .normal)
            button.tintColor = .gray
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.contentVerticalAlignment = .top
            
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 0)
            button.configuration = config
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        updateSelectedTab(index: 0)
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        updateSelectedTab(index: sender.tag)
        onTabSelected?(sender.tag)
    }
    
    private func updateSelectedTab(index: Int) {
        if index != 2 {
            for (idx, button) in buttons.enumerated() {
                let isSelected = idx == index
                button.tintColor = isSelected ? .white : .gray
            }
        }
    }
}
