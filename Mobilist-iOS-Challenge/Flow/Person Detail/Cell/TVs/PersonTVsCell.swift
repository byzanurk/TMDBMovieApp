//
//  PersonTVsCell.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import UIKit

class PersonTVsCell: UICollectionViewCell {
    
    static let identifier = "PersonTVsCell"

    @IBOutlet private weak var tvImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tvImageView.layer.cornerRadius = 8
        tvImageView.clipsToBounds = true
    }

    func configure(with tvShow: Cast) {
        if let path = tvShow.posterPath, !path.isEmpty, let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            tvImageView.kf.setImage(with: url)
            tvImageView.contentMode = .scaleAspectFit
            tvImageView.tintColor = nil
        } else {
            tvImageView.image = UIImage(systemName: "photo")
            tvImageView.contentMode = .scaleAspectFit
            tvImageView.tintColor = .lightGray
        }
    }
    
    override func prepareForReuse() {
        tvImageView.image = nil
    }
}
