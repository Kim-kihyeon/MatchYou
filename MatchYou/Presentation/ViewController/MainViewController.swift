//
//  MainViewController.swift
//  MatchYou
//
//  Created by 김견 on 3/2/25.
//

import UIKit
import SnapKit
import FirebaseAuth

class MainViewController: UIViewController {
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
