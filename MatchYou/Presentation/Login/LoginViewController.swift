//
//  ViewController.swift
//  MatchYou
//
//  Created by 김견 on 2/5/25.
//

import UIKit
import SnapKit
import RxSwift
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    private let viewModel: LoginViewModelProtocol
    private let loginButtonTapped = PublishSubject<OAuthProviderType>()
    private let disposeBag = DisposeBag()
    
    //MARK: - View
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.font = UIFont(name: "OTSBAggroB", size: 80)
        label.text = "맞춰유"
        return label
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "HandshakeIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image?.resizeImageTo(size: CGSize(width: 100, height: 100))
        return imageView
    }()
    
    private let googleSignInButton: UIButton = SignInButton(withProvider: .google)
    private let appleSignInButton: UIButton = SignInButton(withProvider: .apple)
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    //MARK: - Initialize
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .matchYouBackground
        setUI()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUI() {
        stackView.addArrangedSubview(logoLabel)
        stackView.addArrangedSubview(logoImage)
        stackView.addArrangedSubview(googleSignInButton)
        stackView.addArrangedSubview(appleSignInButton)
        stackView.setCustomSpacing(10, after: logoLabel)
        stackView.setCustomSpacing(80, after: logoImage)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            //            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
    }
    
    private func bindView() {
        googleSignInButton.rx.tap
            .map { OAuthProviderType.google }
            .observe(on: MainScheduler.instance)
            .bind(to: loginButtonTapped)
            .disposed(by: disposeBag)
        
        appleSignInButton.rx.tap
            .map { OAuthProviderType.apple }
            .observe(on: MainScheduler.instance)
            .bind(to: loginButtonTapped)
            .disposed(by: disposeBag)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(oAuthProviderType: loginButtonTapped.asObservable())
        let output = viewModel.transform(input: input)
        
        output.user
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] user in
                let mainViewController = MainViewController(user: user)
                self?.navigationController?.setViewControllers([mainViewController], animated: true)
        }
        .disposed(by: disposeBag)
        
        output.error.bind { [weak self] errorMessage in
            let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            DispatchQueue.main.async {
                self?.present(alert, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}

final class SignInButton: UIButton {
    private let withProvider: OAuthProviderType
    init(withProvider: OAuthProviderType) {
        self.withProvider = withProvider
        super.init(frame: .zero)
        
        let title: String = {
            switch withProvider {
            case .google:
                "구글"
            case .apple:
                "애플"
            }
        }()
        
        let image: UIImage = {
            switch withProvider {
            case .google:
                UIImage(named: "GoogleIcon") ?? UIImage()
            case .apple:
                UIImage(systemName: "applelogo")?.withRenderingMode(.alwaysTemplate).withTintColor(.white) ?? UIImage()
            }
        }()
        
        let titleColor: UIColor = {
            switch withProvider {
            case .google:
                    .black
            case .apple:
                    .white
            }
        }()
        
        let backgroundColor: UIColor = {
            switch withProvider {
            case .google:
                    .white
            case .apple:
                    .black
            }
        }()
        
        let attributedTitle = NSAttributedString(
            string: "\(title)로 시작하기",
            attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: titleColor
            ]
        )
        setAttributedTitle(attributedTitle, for: .normal)
        
        if let image = image.resizeImageTo(size: CGSize(width: 28, height: 28)) {
            setImage(image, for: .normal)
            imageView?.contentMode = .scaleAspectFit
        }
        
        var config = configuration ?? UIButton.Configuration.plain()
        config.imagePadding = 16
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        
        configuration = config
        
        contentVerticalAlignment = .center
        
        snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        layer.cornerRadius = 8
        layer.masksToBounds = false
        
        self.backgroundColor = backgroundColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
        
        addTarget(self, action: #selector(didHighlight), for: .touchDown)
        addTarget(self, action: #selector(didEndHighlight), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func didHighlight() {
        layer.opacity = 0.5
    }
    
    @objc private func didEndHighlight() {
        layer.opacity = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
