//
//  PersonDetailViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import Foundation

protocol PersonDetailViewModelProtocol {
    var delegate: PersonDetailViewModelOutput? { get set }
    var personDetail: PersonDetail { get set }
    var movies: [Cast] { get set }
    var tvShows: [Cast] { get set }
    var movie: [Movie] { get set }
    func fetchPersonDetail()
    func fetchMovieCredits()
    func fetchTVCredits()
}

protocol PersonDetailViewModelOutput: AnyObject {
    func didFetchPersonDetail()
    func didFetchMovieCredits()
    func didFetchTVCredits()
    func showError(message: String)
}


final class PersonDetailViewModel: PersonDetailViewModelProtocol {
    
    // MARK: - Properties
    var personDetail: PersonDetail
    var movies: [Cast]
    var tvShows: [Cast]
    var movie: [Movie]
    var personId: Int?
    
    var delegate: PersonDetailViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(
        personDetail: PersonDetail,
        movies: [Cast],
        tvShows: [Cast],
        movie: [Movie],
        personId: Int? = nil,
        delegate: PersonDetailViewModelOutput? = nil,
        service: NetworkRouterProtocol)
    {
        self.personDetail = personDetail
        self.movies = movies
        self.tvShows = tvShows
        self.movie = movie
        self.personId = personId
        self.delegate = delegate
        self.service = service
    }
    
    func fetchPersonDetail() {
        service.fetchPersonDetail(id: personDetail.id) { [weak self] result in
            switch result {
            case .success(let success):
                self?.personDetail = success
                self?.delegate?.didFetchPersonDetail()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }
    
    func fetchMovieCredits() {
        service.fetchMovieCredits(id: personDetail.id) { [weak self] result in
            switch result {
            case .success(let success):
                self?.movies = success.cast
                self?.delegate?.didFetchMovieCredits()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }
    
    func fetchTVCredits() {
        service.fetchTVCredits(id: personDetail.id) { [weak self] result in
            switch result {
            case .success(let success):
                self?.tvShows = success.cast
                self?.delegate?.didFetchTVCredits()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }
    

}
