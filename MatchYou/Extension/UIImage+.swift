//
//  UIImage+resize.swift
//  MatchYou
//
//  Created by 김견 on 2/27/25.
//

import UIKit

extension UIImage {
    convenience init(color: UIColor) {
            let size = CGSize(width: 1, height: 1)
            UIGraphicsBeginImageContext(size)
            color.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.init(cgImage: image!.cgImage!)
        }
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        let aspectRatio = self.size.width / self.size.height
        
        var newSize: CGSize
        
        if size.width / size.height > aspectRatio {
            // 새로운 높이에 맞춰서 가로 크기 계산
            newSize = CGSize(width: size.height * aspectRatio, height: size.height)
        } else {
            // 새로운 가로에 맞춰서 세로 크기 계산
            newSize = CGSize(width: size.width, height: size.width / aspectRatio)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
