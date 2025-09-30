//
//  UIStackView+Rating.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 28.09.2025.
//

import Foundation
import UIKit

extension UIStackView {
    func setFillRatio(_ ratio: CGFloat) {
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.frame.width * ratio,
                                 height: self.bounds.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
        self.layer.mask = maskLayer
    }
}
