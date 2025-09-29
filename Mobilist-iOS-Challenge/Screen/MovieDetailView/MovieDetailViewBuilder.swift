//
//  MovieDetailViewBuilder.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 27.09.2025.
//

import Foundation
import UIKit

// MARK: - MovieDetailViewBuilder
struct MovieDetailViewBuilder {
    static func build(coordinator: Coordinator, movie: Movie) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = MovieDetailViewModel(service: service, movie: movie)
        let storyboard = UIStoryboard(name: "MovieDetailViewController", bundle: nil)
        guard let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return UIViewController()}
        
        movieDetailVC.viewModel = viewModel
        movieDetailVC.coordinator = coordinator
        return movieDetailVC
    }
}
