//
//  CastCell.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import UIKit
import Kingfisher

class CastCell: UICollectionViewCell {

    static let identifier = "CastCell"
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        personImageView.layer.cornerRadius = 8
        personImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        personImageView.image = nil
        nameLabel.text = nil
    }

    func configure(with cast: Cast) {
        nameLabel.text = cast.name
        if let profilePath = cast.profilePath {
            let url = URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)")
            personImageView.kf.setImage(with: url)
        } else {
            personImageView.image = UIImage(systemName: "person.fill")
        }
    }
}
