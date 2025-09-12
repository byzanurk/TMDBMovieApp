//
//  MainViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 12.09.2025.
//

import Foundation

class MainViewModel {
    
    var movies: [Movie] = []
    
    func fetchPopularMovies(completion: @escaping (Bool) -> Void) {
        let path = "\(NetworkPaths.popularMovies.rawValue)?api_key=\(Config.tmdbApiKey)&language=en-US&page=1"
        NetworkManager.shared.request(
            path: path,
            method: .get,
            headers: nil,
            parameters: nil,
            responseType: MovieResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies = response.results
                completion(true)
            case .failure(let error):
                print("Error fetching popular movies:", error)
                completion(false)
            }
        }
    }
    
}

