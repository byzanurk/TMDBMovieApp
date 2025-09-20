//
//  MovieDetailViewController.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 18.09.2025.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    var movie: Movie?
    var youtubeVideos: [YouTubeVideo] = []
    var cast: [Cast] = []
    
    private let viewModel = MovieDetailViewModel(networkManager: NetworkManager.shared)
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var youtubeTrailerCollectionView: UICollectionView!
    @IBOutlet private weak var castCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeTrailerCollectionView.delegate = self
        youtubeTrailerCollectionView.dataSource = self
        youtubeTrailerCollectionView.register(UINib(nibName: "YoutubeTrailerCell", bundle: nil), forCellWithReuseIdentifier: "YoutubeTrailerCell")
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.register(UINib(nibName: "CastCell", bundle: nil), forCellWithReuseIdentifier: "CastCell")
        
        configureUI()
        loadYoutubeTrailers()
        loadCast()
    }
    
    private func configureUI() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title
        titleLabel.numberOfLines = 2
        
        overviewLabel.text = movie.overview
        overviewLabel.numberOfLines = 0

        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
                
        if !movie.posterPath.isEmpty {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
            posterImageView.kf.setImage(with: url)
            backgroundImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(_):
                    let blurEffect = UIBlurEffect(style: .light)
                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                    blurEffectView.frame = self?.backgroundImageView.bounds ?? .zero
                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self?.backgroundImageView.addSubview(blurEffectView)
                case .failure(_):
                    break
                }
            }
        } else {
            posterImageView.image = UIImage(systemName: "photo")
            backgroundImageView.image = nil
        }
    }
    
    private func loadYoutubeTrailers() {
        guard let movieTitle = movie?.title else { return }
        viewModel.fetchYoutubeVideos(for: movieTitle) { [weak self] videos in
            guard let self = self else { return }
            self.youtubeVideos = videos
            DispatchQueue.main.async {
                self.youtubeTrailerCollectionView.reloadData()
            }
        }
    }
    
    private func loadCast() {
        guard let movieId = movie?.id else { return }
        viewModel.fetchMovieCast(movieId: movieId) { [weak self] castArray in
            print("Fetched cast:", castArray)
            guard let self = self else { return }
            self.cast = castArray
            DispatchQueue.main.async {
                self.castCollectionView.reloadData()
            }
        }
    }

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == youtubeTrailerCollectionView {
            return youtubeVideos.count
        } else if collectionView == castCollectionView {
            return min(cast.count, 40)
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
            let video = youtubeVideos[indexPath.item]
            cell.configure(with: video)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCell
            let actor = cast[indexPath.item]
            cell.configure(with: actor)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == youtubeTrailerCollectionView {
            let video = youtubeVideos[indexPath.item]
            if let url = video.videoURL {
                UIApplication.shared.open(url)
            }
        } else if collectionView == castCollectionView {
            let selectedCast = cast[indexPath.item]
            let storyboard = UIStoryboard(name: "PersonDetailViewController", bundle: nil)
            if let personDetailVC = storyboard.instantiateViewController(withIdentifier: "PersonDetailViewController") as? PersonDetailViewController {
                personDetailVC.personId = selectedCast.castId
                navigationController?.pushViewController(personDetailVC, animated: true)
            }
        }
    }
}
