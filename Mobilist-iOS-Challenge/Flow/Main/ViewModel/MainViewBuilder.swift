//
//  MainViewBuilder.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 25.09.2025.
//

import Foundation
import UIKit

// MARK: - MainViewBuilder
struct MainViewBuilder {
    static func build(coordinator: Coordinator) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = MainViewModel(service: service)
        let storyboard = UIStoryboard(name: "MainViewController", bundle: nil)
        guard let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return UIViewController()}
        
        mainVC.viewModel = viewModel
        mainVC.coordinator = coordinator
        return mainVC
    }
}
