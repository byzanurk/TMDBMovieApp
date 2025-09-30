//
//  PersonMoviesCell.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import UIKit

final class PersonMoviesCell: UICollectionViewCell {

    static let identifier = "PersonMoviesCell"
    
    @IBOutlet private weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.layer.cornerRadius = 8
        movieImageView.clipsToBounds = true
    }
    
    func configure(with cast: Cast) {
        guard let path = cast.posterPath, !path.isEmpty,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            movieImageView.image = UIImage(systemName: "photo")
            movieImageView.contentMode = .scaleAspectFit
            movieImageView.tintColor = .lightGray
            return
        }
        movieImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
}
