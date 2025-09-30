//
//  Coordinator.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 25.09.2025.
//

import Foundation
import UIKit

// MARK: - Coordinator
final class Coordinator: CoordinatorProtocol {
    // MARK: - Properties
    var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController?
    
    // MARK: - Functions
    func start() {
        let vc = MainViewBuilder.build(coordinator: self)
        navigationController?.setViewControllers([vc],
                                                 animated: true)
    }

    func eventOccurred(with viewController: UIViewController) {
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
}
