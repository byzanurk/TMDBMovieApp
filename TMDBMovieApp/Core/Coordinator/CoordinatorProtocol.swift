//
//  CoordinatorProtocol.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 25.09.2025.
//

import Foundation
import UIKit

// MARK: - CoordinatorProtocol
protocol CoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: CoordinatorProtocol? { get set }
    func eventOccurred(with viewController: UIViewController)
    func start()
}
