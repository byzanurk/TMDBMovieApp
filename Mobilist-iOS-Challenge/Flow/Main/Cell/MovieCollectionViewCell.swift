//
//  MovieCollectionViewCell.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 11.09.2025.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = false
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOpacity = 0.1
        posterImageView.layer.shadowRadius = 4
        posterImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        titleLabel.numberOfLines = 2
        overviewLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        let imageUrl = "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
        if let url = URL(string: imageUrl) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }

}
