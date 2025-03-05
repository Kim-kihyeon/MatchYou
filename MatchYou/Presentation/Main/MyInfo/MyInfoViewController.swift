//
//  MyInfoViewController.swift
//  MatchYou
//
//  Created by 김견 on 3/5/25.
//

import UIKit
import SnapKit

class MyInfoViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let label = UILabel()
        label.text = "내 정보"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
