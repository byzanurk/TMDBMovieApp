//
//  PersonDetailViewController.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import UIKit
import Kingfisher

class PersonDetailViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: PersonDetailViewModelProtocol!
    var coordinator: Coordinator!
    
    // MARK: - Outlets
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var personImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var jobLabel: UILabel!
    @IBOutlet private weak var biographyLabel: UILabel!
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    @IBOutlet private weak var tvCollectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupCollectionViews()
        configureInitialState()
    }
    
    private func setupCollectionViews() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib(nibName: "PersonMoviesCell", bundle: nil), forCellWithReuseIdentifier: "PersonMoviesCell")
        
        tvCollectionView.delegate = self
        tvCollectionView.dataSource = self
        tvCollectionView.register(UINib(nibName: "PersonTVsCell", bundle: nil), forCellWithReuseIdentifier: "PersonTVsCell")
    }
        
    private func configureInitialState() {
        updateUI(with: viewModel.personDetail)
        viewModel.fetchPersonDetail()
        viewModel.fetchMovieCredits()
        viewModel.fetchTVCredits()
    }
    
    // MARK: - UI Update
    private func updateUI(with detail: PersonDetail?) {
        guard let detail = detail else { return }
        nameLabel.text = detail.name.isEmpty ? "Name not available.." : detail.name
        
        jobLabel.text = detail.knownForDepartment.isEmpty ? "Job info not available.." : detail.knownForDepartment
        
        biographyLabel.text = detail.biography.isEmpty ? "Biography not available.." : detail.biography
        biographyLabel.numberOfLines = 0

        personImageView.layer.cornerRadius = 8
        personImageView.layer.masksToBounds = true

        if let path = detail.profilePath, !path.isEmpty {
            personImageView.setImageFromPath(path, systemImageName: "person.fill")
            backgroundImageView.setImageFromPath(path)
            backgroundImageView.applyBlurEffect()
        } else {
            personImageView.image = UIImage(systemName: "person.fill")
            backgroundImageView.image = UIImage(systemName: "photo")
        }
            
    }

}

extension PersonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieCollectionView {
            return viewModel.movies?.cast.count ?? 0
        } else {
            return viewModel.tvShows?.cast.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonMoviesCell", for: indexPath) as! PersonMoviesCell
            guard let cast = viewModel.movies?.cast[indexPath.item] else { return UICollectionViewCell() }
            cell.configure(with: cast)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonTVsCell", for: indexPath) as! PersonTVsCell
            guard let tvShow = viewModel.tvShows?.cast[indexPath.item] else { return UICollectionViewCell() }
            cell.configure(with: tvShow)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == movieCollectionView {
            let cast = viewModel.movies?.cast[indexPath.item]
            guard let id = cast?.id else { return }
            // cast -> movie - BURAYA BAKILACAK
            let movie = Movie(
                id: id,
                title: cast?.title ?? "",
                overview: "",
                posterPath: cast?.posterPath,
                voteAverage: 0.0
            )
            let vc = MovieDetailViewBuilder.build(coordinator: self.coordinator, movie: movie)
            navigate(to: vc, coordinator: coordinator)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == movieCollectionView {
            let width = collectionView.frame.width / 3 - 8
            return CGSize(width: width, height: width * 1.5)
        } else {
            let width = collectionView.frame.width / 3 - 8
            return CGSize(width: width, height: width * 1.5)
        }
    }
}


extension PersonDetailViewController: PersonDetailViewModelOutput {
    func didFetchPersonDetail() {
        updateUI(with: viewModel.personDetail)
    }
    
    func didFetchMovieCredits() {
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
    
    func didFetchTVCredits() {
        DispatchQueue.main.async {
            self.tvCollectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("Error: \(message)")
    }
}
