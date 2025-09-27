//
//  MoviewDetailViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 18.09.2025.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelOutput? { get set }
    var youtubeVideos: [YouTubeVideo] { get set }
    var cast: [Cast] { get set }
    var movie: Movie { get set }
    func fetchYoutubeVideos()
    func fetchMovieCast()
    func fetchMovieDetail()
}

protocol MovieDetailViewModelOutput: AnyObject {
    func didFetchYoutubeVideos()
    func didFetchMovieCast()
    func didFetchMovieDetail()
    func showError(message: String)
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    // MARK: - Properties
    var movie: Movie
    var movieId: Int?
    var youtubeVideos: [YouTubeVideo] = []
    var cast: [Cast] = []

    
    var delegate: MovieDetailViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol, movie: Movie) {
        self.service = service
        self.movie = movie
    }
    
    // MARK: - YouTube Videos
    func fetchYoutubeVideos() {
        service.fetchYoutubeVideos(for: movie.title) { [weak self] result in
            switch result {
            case .success(let success):
                self?.youtubeVideos = success.items
                self?.delegate?.didFetchYoutubeVideos()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }
    
    // MARK: - Movie Cast
    func fetchMovieCast() {
        service.fetchMovieCast(for: movie.id) { [weak self] result in
            switch result {
            case .success(let success):
                self?.cast = success.cast
                self?.delegate?.didFetchMovieCast()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }

    // MARK: - Movie Detail
    func fetchMovieDetail() {
        service.fetchMovieDetail(for: movie.id) { [weak self] result in
            switch result {
            case .success(let success):
                self?.movie = success
                self?.delegate?.didFetchMovieDetail()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }
    
}
