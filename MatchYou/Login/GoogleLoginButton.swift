//
//  GoogleLoginButton.swift
//  MatchYou
//
//  Created by 김견 on 2/6/25.
//

import UIKit

@IBDesignable
class GoogleLoginButton: UIView {
        
    @IBOutlet weak var titleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "GoogleLoginButton") else { return }
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false 
        view.frame = self.bounds
        view.layer.cornerRadius = 8
        
        titleLabel.font = UIFont(name: "OTSBAggroM", size: 20)

        self.addSubview(view)
    }
}
