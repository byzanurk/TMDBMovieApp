//
//  MainViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 12.09.2025.
//

import Foundation

class MainViewModel {
    
    var movies: [Movie] = []
    private var allPopularMovies: [Movie] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isFetching = false
    
    func fetchPopularMovies(completion: @escaping (Bool) -> Void) {
        guard !isFetching else { return }
        guard currentPage <= totalPages else { completion(false); return }

        isFetching = true

        let path = "\(NetworkPaths.popularMovies.rawValue)?api_key=\(Config.tmdbApiKey)&language=en-US&page=\(currentPage)"
        NetworkManager.shared.request(
            path: path,
            method: .get,
            headers: nil,
            parameters: nil,
            responseType: MovieResponse.self
        ) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let response):
                self.movies.append(contentsOf: response.results)
                self.allPopularMovies.append(contentsOf: response.results)
                self.totalPages = response.totalPages
                self.currentPage += 1
                completion(true)
            case .failure(let error):
                print("Error fetching popular movies:", error)
                completion(false)
            }
        }
    }
    
    func searchMovies(query: String, completion: @escaping (Bool) -> Void) {
        guard !query.isEmpty else {
            self.movies = self.allPopularMovies
            completion(true)
            return
        }
        self.movies = self.allPopularMovies.filter { $0.title.lowercased().contains(query.lowercased()) }
        completion(true)
    }
    
}
