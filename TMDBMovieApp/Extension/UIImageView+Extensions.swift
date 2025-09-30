//
//  UIImageView+Extensions.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 28.09.2025.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImageFromPath(_ path: String?, systemImageName: String = "photo") {
        guard let path = path, !path.isEmpty, let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            return
        }
        self.kf.setImage(with: url, placeholder: UIImage(systemName: systemImageName))
    }
    
    func applyBlurEffect() {
        self.subviews.forEach {if $0 is UIVisualEffectView {$0.removeFromSuperview()}}
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
