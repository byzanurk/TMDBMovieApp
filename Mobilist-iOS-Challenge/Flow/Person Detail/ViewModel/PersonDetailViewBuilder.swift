//
//  PersonDetailViewBuilder.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 28.09.2025.
//

import Foundation
import UIKit

struct PersonDetailViewBuilder {
    static func build(coordinator: Coordinator, personId: Int) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = PersonDetailViewModel(personId: personId, service: service)
        let storyboard = UIStoryboard(name: "PersonDetailViewController", bundle: nil)
        guard let personDetailVC = storyboard.instantiateViewController(withIdentifier: "PersonDetailViewController") as? PersonDetailViewController else { return UIViewController() }
        
        personDetailVC.coordinator = coordinator
        personDetailVC.viewModel = viewModel
        return personDetailVC
    }
}
