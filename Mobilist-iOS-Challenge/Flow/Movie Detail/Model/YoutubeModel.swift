//
//  YoutubeModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import Foundation

struct YouTubeSearchResponse: Decodable {
    let items: [YouTubeVideo]
}

struct YouTubeVideo: Decodable {
    let id: VideoID
    let snippet: Snippet
    
    var videoURL: URL? {
        URL(string: "https://www.youtube.com/watch?v=\(id.videoId)")
    }
    
    var title: String {
        snippet.title
    }
    
    var thumbnailURL: String {
        snippet.thumbnails.high.url
    }
}

struct VideoID: Decodable {
    let videoId: String
}

struct Snippet: Decodable {
    let title: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Decodable {
    let high: ThumbnailInfo
}

struct ThumbnailInfo: Decodable {
    let url: String
}
