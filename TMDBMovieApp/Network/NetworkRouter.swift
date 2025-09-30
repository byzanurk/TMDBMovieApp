//
//  NetworkRouter.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 25.09.2025.
//

protocol NetworkRouterProtocol {
    func fetchPopularMovies(currentPage:Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void)
    func fetchYoutubeVideos(for movieTitle: String, completion: @escaping (Result<YouTubeSearchResponse, NetworkError>) -> Void)
    func fetchMovieCast(for movieId: Int, completion: @escaping (Result<MovieCreditsResponse, NetworkError>) -> Void)
    func fetchMovieDetail(for id: Int, completion: @escaping (Result<Movie, NetworkError>) -> Void)
    func fetchPersonDetail(id: Int, completion: @escaping (Result<PersonDetail, NetworkError>) -> Void)
    func fetchMovieCredits(id: Int, completion: @escaping (Result<MovieCreditsResponse, NetworkError>) -> Void)
    func fetchTVCredits(id: Int, completion: @escaping (Result<TVCreditsResponse, NetworkError>) -> Void)
}

final class NetworkRouter: NetworkRouterProtocol {
    
    let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol = NetworkManager()) {
        self.service = service
    }
    
    // MARK: - Main
    func fetchPopularMovies(currentPage:Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let path = "\(NetworkPaths.popularMovies.rawValue)?api_key=\(Config.tmdbApiKey)&language=en-US&page=\(currentPage)"
        
        service.request(
            path: path,
            responseType: MovieResponse.self,
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            method: .get,
            headers: nil,
            parameters: nil,
            completion: completion)
    }
    
    // MARK: - Movie Detail
    func fetchYoutubeVideos(for movieTitle: String, completion: @escaping (Result<YouTubeSearchResponse, NetworkError>) -> Void) {
        let query = (movieTitle + " trailer").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? movieTitle
        let path = "/search?part=snippet&q=\(query)&key=\(Config.youtubeApiKey)&maxResults=5&type=video"
        
        service.request(
            path: path,
            responseType: YouTubeSearchResponse.self,
            baseURL: Config.APIBaseURL.youtubeBaseURL,
            method: .get,
            headers: nil,
            parameters: nil,
            completion: completion)
        
    }
    
    func fetchMovieCast(for movieId: Int, completion: @escaping (Result<MovieCreditsResponse, NetworkError>) -> Void) {
        let path = "/movie/\(movieId)/credits?api_key=\(Config.tmdbApiKey)"

        service.request(
            path: path,
            responseType: MovieCreditsResponse.self,
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            method: .get,
            headers: nil,
            parameters: nil,
            completion: completion)
    }
    
    func fetchMovieDetail(for id: Int, completion: @escaping (Result<Movie, NetworkError>) -> Void) {
        let path = "/movie/\(id)"

        service.request(
            path: path,
            responseType: Movie.self,
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            method: .get,
            headers: nil,
            parameters: nil,
            completion: completion)
    }
    
    // MARK: - Person Detail
    func fetchPersonDetail(id: Int, completion: @escaping (Result<PersonDetail, NetworkError>) -> Void) {
        let path = "/person/\(id)?api_key=\(Config.tmdbApiKey)&language=en-US"

        service.request(
            path: path,
            responseType: PersonDetail.self,
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            method: .get,
            headers: nil,
            parameters: nil,
            completion: completion)
    }
    
    func fetchMovieCredits(id: Int, completion: @escaping (Result<MovieCreditsResponse, NetworkError>) -> Void) {
        let path = "/person/\(id)/movie_credits?api_key=\(Config.tmdbApiKey)&language=en-US"
        
        service.request(
            path: path,
            responseType: MovieCreditsResponse.self,
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            method: .get,
            headers: nil,
            parameters: nil,
            completion: completion)
    }
    
    func fetchTVCredits(id: Int, completion: @escaping (Result<TVCreditsResponse, NetworkError>) -> Void) {
        let path = "/person/\(id)/tv_credits?api_key=\(Config.tmdbApiKey)&language=en-US"

        service.request(
            path: path,
            responseType: TVCreditsResponse.self,
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            method: .get,
            headers: nil,
            parameters: nil,
            completion: completion)
    }
    
}
