//
//  MainViewController.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 10.09.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    let viewModel = MainViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        fetchInitialMovies()
    }
    
    // MARK: - Setup
    private func setupUI() {
        searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    // MARK: - Data Fetching
    private func fetchInitialMovies() {
        let startIndex = viewModel.movies.count
        viewModel.fetchPopularMovies { [weak self] success in
            if success, let self = self {
                let endIndex = self.viewModel.movies.count
                let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                self.collectionView.insertItems(at: indexPaths)
            }
        }
    }
    
    // MARK: - Scroll Handling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            viewModel.fetchPopularMovies { [weak self] success in
                if success {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    // MARK: - Navigation
    private func navigateToDetail(for movie: Movie) {
        let storyboard = UIStoryboard(name: "MovieDetailViewController", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
            detailVC.movie = movie
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

// MARK: - Collection View Extension
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 12
        return CGSize(width: width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.row]
        navigateToDetail(for: selectedMovie)
    }
}

// MARK: - Search Bar Extension
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(query: searchText) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}
