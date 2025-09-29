//
//  MovieCollectionViewCell.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 11.09.2025.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        overviewLabel.text = nil
        posterImageView.image = nil
    }
    
    // MARK: - Configuration
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        let imageUrl = "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
        if let url = URL(string: imageUrl) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }

}
