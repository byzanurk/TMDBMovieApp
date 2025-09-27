//
//  NetworkRouter.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 25.09.2025.
//

protocol NetworkRouterProtocol {
    func fetchPopularMovies(currentPage:Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void)
}

final class NetworkRouter: NetworkRouterProtocol {
    
    let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol = NetworkManager()) {
        self.service = service
    }
    
    func fetchPopularMovies(currentPage:Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let path = "\(NetworkPaths.popularMovies.rawValue)?api_key=\(Config.tmdbApiKey)&language=en-US&page=\(currentPage)"
        service.request(path: path, responseType: MovieResponse.self, baseURL: Config.APIBaseURL.tmdbBaseURL, method: .get, headers: nil, parameters: nil, completion: completion)
    }
}
