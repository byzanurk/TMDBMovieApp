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
    private let viewModel = MovieDetailViewModel(networkManager: NetworkManager.shared)
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var youtubeTrailerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeTrailerCollectionView.delegate = self
        youtubeTrailerCollectionView.dataSource = self
        youtubeTrailerCollectionView.register(UINib(nibName: "YoutubeTrailerCell", bundle: nil), forCellWithReuseIdentifier: "YoutubeTrailerCell")
        
        configureUI()
        loadYoutubeTrailers()
    }
    
    private func configureUI() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        
        titleLabel.numberOfLines = 2
        overviewLabel.numberOfLines = 0
        
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

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youtubeVideos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * (16.0 / 9.0)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YoutubeTrailerCell.identifier, for: indexPath) as? YoutubeTrailerCell else {
            return UICollectionViewCell()
        }
        let video = youtubeVideos[indexPath.item]
        cell.configure(with: video)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = youtubeVideos[indexPath.item]
        if let url = video.videoURL {
            UIApplication.shared.open(url)
        }
    }
}
