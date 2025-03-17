//
//  UIButton+.swift
//  MatchYou
//
//  Created by 김견 on 3/6/25.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let colorImage = UIImage(color: color)
        self.setBackgroundImage(colorImage, for: state)
    }
}
