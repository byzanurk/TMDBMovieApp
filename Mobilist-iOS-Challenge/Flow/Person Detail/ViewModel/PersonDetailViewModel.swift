//
//  PersonDetailViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import Foundation

final class PersonDetailViewModel {
    
    var personDetail: PersonDetail?
    var movies: [Cast] = []
    var tvShows: [Cast] = []
    
    // MARK: - Person Detail
    func fetchPersonDetail(id: Int, completion: @escaping () -> Void) {
        let baseURL = Config.APIBaseURL.tmdbBaseURL
        let path = "/person/\(id)"
        
        NetworkManager.shared.request(
            baseURL: baseURL,
            path: path,
            method: .get,
            headers: nil,
            parameters: ["api_key": Config.tmdbApiKey, "language": "en-US"],
            responseType: PersonDetail.self
        ) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.personDetail = detail
                completion()
            case .failure(let error):
                print("Error fetching person detail:", error)
            }
        }
    }
    
    // MARK: - Movie Credits
    func fetchMovieCredits(id: Int, completion: @escaping () -> Void) {
        let baseURL = Config.APIBaseURL.tmdbBaseURL
        let path = "/person/\(id)/movie_credits"
        
        NetworkManager.shared.request(
            baseURL: baseURL,
            path: path,
            method: .get,
            headers: nil,
            parameters: ["api_key": Config.tmdbApiKey, "language": "en-US"],
            responseType: MovieCreditsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies = response.cast
                completion()
            case .failure(let error):
                print("Error fetching movie credits:", error)
            }
        }
    }
    
    // MARK: - TV Credits
    func fetchTVCredits(id: Int, completion: @escaping () -> Void) {
        let baseURL = Config.APIBaseURL.tmdbBaseURL
        let path = "/person/\(id)/tv_credits"
        NetworkManager.shared.request(
            baseURL: baseURL,
            path: path,
            method: .get,
            headers: nil,
            parameters: ["api_key": Config.tmdbApiKey, "language": "en-US"],
            responseType: TVCreditsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                self?.tvShows = response.cast
                completion()
            case .failure(let error):
                print("Error fetching tv credits:", error)
            }
        }
    }
    
}
