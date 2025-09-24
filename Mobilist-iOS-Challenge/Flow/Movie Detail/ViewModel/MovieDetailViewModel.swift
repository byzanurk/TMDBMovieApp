//
//  MoviewDetailViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 18.09.2025.
//

import Foundation

class MovieDetailViewModel {
    
    // DI
    private let networkManager: NetworkManagerProtocol
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchYoutubeVideos(for movieTitle: String, completion: @escaping ([YouTubeVideo]) -> Void) {
        let baseURL =  Config.APIBaseURL.youtubeBaseURL
        let apiKey = Config.youtubeApiKey
        let query = (movieTitle + "trailer").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? movieTitle
        let path = "/search?part=snippet&q=\(query)&key=\(apiKey)&maxResults=5&type=video"
        
        networkManager.request(
            baseURL: baseURL,
            path: path,
            method: .get,
            headers: nil,
            parameters: nil,
            responseType: YouTubeSearchResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response.items)
            case .failure(let error):
                print("MovieDetailViewModel-FetchYoutubeVideos error:", error)
                completion([])
            }
        }
    }
    
    func fetchMovieCast(movieId: Int, completion: @escaping ([Cast]) -> Void) {
        let path = "/movie/\(movieId)/credits?api_key=\(Config.tmdbApiKey)"
        
        networkManager.request(
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            path: path,
            method: .get,
            headers: nil,
            parameters: nil,
            responseType: MovieCreditsResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response.cast)
            case .failure(let error):
                print("error fething cast:", error)
                completion([])
            }
        }
    }

    
    
    // buraya bak bi daha
    func fetchMovieDetail(id: Int, completion: @escaping (Movie?) -> Void) {
        let path = "/movie/\(id)"
        networkManager.request(
            baseURL: Config.APIBaseURL.tmdbBaseURL,
            path: path,
            method: .get,
            headers: nil,
            parameters: ["api_key": Config.tmdbApiKey, "language": "en-US"],
            responseType: Movie.self
        ) { result in
            switch result {
            case .success(let movie):
                completion(movie)
            case .failure(let error):
                print("Error fetching movie detail:", error)
                completion(nil)
            }
        }
    }
    
}
