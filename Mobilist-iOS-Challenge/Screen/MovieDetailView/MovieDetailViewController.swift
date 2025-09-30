//
//  MovieDetailViewController.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 18.09.2025.
//

import UIKit
import Kingfisher

final class MovieDetailViewController: UIViewController {

    var viewModel: MovieDetailViewModelProtocol!
    var coordinator: Coordinator!
    
    // MARK: - Outlets
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var youtubeTrailerCollectionView: UICollectionView!
    @IBOutlet private weak var castCollectionView: UICollectionView!
    @IBOutlet private weak var emptyStarsStackView: UIStackView!
    @IBOutlet private weak var filledStarsStackView: UIStackView!
    @IBOutlet private weak var filledStarsWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupCollectionViews()
        configureInitialState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateStarsRating(voteAverage: viewModel.movie.voteAverage ?? 0)
    }

    // MARK: - Setup
    private func setupCollectionViews() {
        youtubeTrailerCollectionView.delegate = self
        youtubeTrailerCollectionView.dataSource = self
        youtubeTrailerCollectionView.register(UINib(nibName: "YoutubeTrailerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "YoutubeTrailerCollectionViewCell")
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
    }
        
    private func configureInitialState() {
        updateUI(with: viewModel.movie)
        viewModel.fetchYoutubeVideos()
        viewModel.fetchMovieCast()
    }
    
    private func updateUI(with movie: Movie) {
        titleLabel.text = movie.title?.isEmpty ?? false ? "No Title Available" : movie.title
        titleLabel.numberOfLines = 2
        
        overviewLabel.text = movie.overview?.isEmpty ?? false ? "No Overview Available" : movie.overview
        overviewLabel.numberOfLines = 0

        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true

                
        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            posterImageView.setImageFromPath(posterPath, systemImageName: "photo")
            backgroundImageView.setImageFromPath(posterPath)
            backgroundImageView.applyBlurEffect()
        } else {
            posterImageView.image = UIImage(systemName: "photo")
            backgroundImageView.image = UIImage(systemName: "photo")
        }
    }
    
    // MARK: - Star Rating
    private func updateStarsRating(voteAverage: Double) {
        let ratio = CGFloat(voteAverage / 10.0)
        filledStarsStackView.setFillRatio(ratio)
    }
    
}

// MARK: - Collection View Extension
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == youtubeTrailerCollectionView {
            return viewModel.youtubeVideos.count
        } else if collectionView == castCollectionView {
            return min(viewModel.cast.count, 40)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == youtubeTrailerCollectionView {
            let height = collectionView.frame.height
            let width = height * (16.0 / 9.0)
            return CGSize(width: width, height: height)
        } else {
            let height = collectionView.frame.height
            let width = height
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == youtubeTrailerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YoutubeTrailerCollectionViewCell", for: indexPath) as! YoutubeTrailerCollectionViewCell
            let video = viewModel.youtubeVideos[indexPath.item]
            cell.configure(with: video)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
            let actor = viewModel.cast[indexPath.item]
            cell.configure(with: actor)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == youtubeTrailerCollectionView {
            let video = viewModel.youtubeVideos[indexPath.item]
            if let url = video.videoURL {
                UIApplication.shared.open(url)
            }
        } else if collectionView == castCollectionView {
            let selectedCast = viewModel.cast[indexPath.item]
            guard let personId = selectedCast.id else {
                print("MovieDetailVC: selected cast has no person id. cast entry:\(selectedCast)")
                return
            }
            print("MovieDetailVC: navigating to person id:\(personId)")
            let vc = PersonDetailViewBuilder.build(coordinator: self.coordinator, personId: personId)
            navigate(to: vc, coordinator: coordinator)
        }
    }
}

extension MovieDetailViewController: MovieDetailViewModelOutput {
    func didFetchMovieCast() {
        DispatchQueue.main.async {
            self.castCollectionView.reloadData()
        }
    }
    
    func didFetchMovieDetail() {
        updateUI(with: viewModel.movie)
    }
    
    func didFetchYoutubeVideos() {
        DispatchQueue.main.async {
            self.youtubeTrailerCollectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("Error: \(message)")
    }
    
}
