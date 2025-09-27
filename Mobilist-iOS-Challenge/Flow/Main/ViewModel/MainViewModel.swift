//
//  MainViewModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 12.09.2025.
//

import Foundation

protocol MainViewModelProtocol {
    var movies: [Movie] { get set }
    var delegate: MainViewModelOutput? { get set }
    func fetchPopularMovies()
    func searchMovies(query: String)
}

protocol MainViewModelOutput: AnyObject {
    func popularMovieSuccess()
    func searchSuccess()
    func showError(message: String)
}

final class MainViewModel: MainViewModelProtocol {
    
    var movies: [Movie] = []
    weak var delegate: MainViewModelOutput?
    
    private var allPopularMovies: [Movie] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isFetching = false
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func fetchPopularMovies() {
        guard !isFetching else { return }
        guard currentPage <= totalPages else {  return }

        isFetching = true
        
        service.fetchPopularMovies(currentPage: self.currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                self.movies.append(contentsOf: response.results)
                self.allPopularMovies.append(contentsOf: response.results)
                self.totalPages = response.totalPages
                self.currentPage += 1
                self.delegate?.popularMovieSuccess()
            case .failure(let error):
                self.delegate?.showError(message: error.localizedDescription)
                print("Error fetching popular movies:", error)
            }
        }
    }
    
    func searchMovies(query: String) {
        guard !query.isEmpty else {
            self.movies = self.allPopularMovies
            self.delegate?.searchSuccess()
            return
        }
        self.movies = self.allPopularMovies.filter { $0.title.lowercased().contains(query.lowercased()) }
        self.delegate?.searchSuccess()
    }
}
