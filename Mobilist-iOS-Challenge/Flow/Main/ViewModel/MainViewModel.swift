//
//  MainViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 12.09.2025.
//

import Foundation

class MainViewModel {
    
    var movies: [Movie] = []
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
            return
        }
        
        let path = "\(NetworkPaths.movies.rawValue)?api_key=\(Config.tmdbApiKey)&language=en-US&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        NetworkManager.shared.request(
            path: path,
            method: .get,
            headers: nil,
            parameters: nil,
            responseType: MovieResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                completion(true)
                self?.movies = response.results
            case .failure(let error):
                completion(false)
                print("Error searching movies:", error)
            }
        }
    }
    
}

