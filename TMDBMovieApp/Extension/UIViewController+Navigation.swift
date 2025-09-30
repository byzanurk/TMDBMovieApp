//
//  UIViewController+Navigation.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 28.09.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func navigate(to vc: UIViewController, coordinator: Coordinator) {
        coordinator.eventOccurred(with: vc)
    }
}
