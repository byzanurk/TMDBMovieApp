//
//  PersonMoviesCell.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import UIKit

class PersonMoviesCell: UICollectionViewCell {

    static let identifier = "PersonMoviesCell"
    
    @IBOutlet private weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieImageView.layer.cornerRadius = 8
        movieImageView.clipsToBounds = true
    }
    
    func configure(with movie: Movie) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        movieImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
}
