//
//  PersonDetailViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import Foundation

protocol PersonDetailViewModelProtocol {
    var delegate: PersonDetailViewModelOutput? { get set }
    var personDetail: PersonDetail? { get set }
    var movies: MovieCreditsResponse? { get set }
    var tvShows: TVCreditsResponse? { get set }
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
    var personDetail: PersonDetail?
    var movies: MovieCreditsResponse?
    var tvShows: TVCreditsResponse?
    var personId: Int
    
    var delegate: PersonDetailViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(
        personId: Int,
        service: NetworkRouterProtocol
    ) {
        self.personId = personId
        self.service = service
    }
    
    func fetchPersonDetail() {
        service.fetchPersonDetail(id: personId) { [weak self] result in
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
        service.fetchMovieCredits(id: personId) { [weak self] result in
            switch result {
            case .success(let success):
                self?.movies = success
                self?.delegate?.didFetchMovieCredits()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }
    
    func fetchTVCredits() {
        service.fetchTVCredits(id: personId) { [weak self] result in
            switch result {
            case .success(let success):
                self?.tvShows = success
                self?.delegate?.didFetchTVCredits()
            case .failure(let failure):
                self?.delegate?.showError(message: failure.localizedDescription)
            }
        }
    }
    

}
