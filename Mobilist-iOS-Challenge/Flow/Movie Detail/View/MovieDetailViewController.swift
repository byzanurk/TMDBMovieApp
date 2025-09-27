//
//  MovieDetailViewController.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 18.09.2025.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

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
        updateStarsRating(voteAverage: viewModel.movie.voteAverage)
    }

    // MARK: - Setup
    private func setupCollectionViews() {
        youtubeTrailerCollectionView.delegate = self
        youtubeTrailerCollectionView.dataSource = self
        youtubeTrailerCollectionView.register(UINib(nibName: "YoutubeTrailerCell", bundle: nil), forCellWithReuseIdentifier: "YoutubeTrailerCell")
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.register(UINib(nibName: "CastCell", bundle: nil), forCellWithReuseIdentifier: "CastCell")
    }
        
    private func configureInitialState() {
        updateUI(with: viewModel.movie)
        viewModel.fetchYoutubeVideos()
        viewModel.fetchMovieCast()
        
    }
    
    private func updateUI(with movie: Movie) {
        titleLabel.text = movie.title.isEmpty ? "No Title Available" : movie.title
        titleLabel.numberOfLines = 2
        
        overviewLabel.text = movie.overview.isEmpty ? "No Overview Available" : movie.overview
        overviewLabel.numberOfLines = 0

        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true

                
        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: url)
            backgroundImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(_):
                    self?.applyBlurEffect()
                case .failure(_):
                    break
                }
            }
        } else {
            posterImageView.image = UIImage(systemName: "photo")
            backgroundImageView.image = nil
        }
    }
    
    // helper method
    private func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }
    
    // MARK: - Star Rating
    private func updateStarsRating(voteAverage: Double) {
        let ratingOutOfFive = voteAverage / 2.0
        let fillRatio = ratingOutOfFive / 5.0
        let totalWidth = emptyStarsStackView.frame.width
        
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0,
                                 y: 0,
                                 width: totalWidth * CGFloat(fillRatio),
                                 height: emptyStarsStackView.bounds.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
        
        filledStarsStackView.layer.mask = maskLayer
    }
    
    
    // MARK: - Navigation
    private func navigateToPersonDetail(personId: Int) {
        let storyboard = UIStoryboard(name: "PersonDetailViewController", bundle: nil)
        if let personDetailVC = storyboard.instantiateViewController(withIdentifier: "PersonDetailViewController") as? PersonDetailViewController {
            personDetailVC.personId = personId
            navigationController?.pushViewController(personDetailVC, animated: true)
        }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YoutubeTrailerCell", for: indexPath) as! YoutubeTrailerCell
            let video = viewModel.youtubeVideos[indexPath.item]
            cell.configure(with: video)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCell
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
            navigateToPersonDetail(personId: personId)
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
        print("error: \(message)")
    }
    
}
