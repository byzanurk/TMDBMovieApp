//
//  YoutubeTrailerCell.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 19.09.2025.
//

import UIKit
import Kingfisher

class YoutubeTrailerCell: UICollectionViewCell {

    static let identifier = "YoutubeTrailerCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = nil
    }

    func configure(with video: YouTubeVideo) {
        titleLabel.text = video.title
        thumbnailImageView.kf.setImage(with: URL(string: video.thumbnailURL))
    }
}
