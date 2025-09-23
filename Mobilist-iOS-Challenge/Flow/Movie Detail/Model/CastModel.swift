//
//  MovieCreditsModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import Foundation

struct MovieCreditsResponse: Decodable {
    let id: Int
    let cast: [Cast]
}

struct TVCreditsResponse: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable {
    let castId: Int?
    let id: Int?
    let character: String?
    let name: String? // twshow icin name
    let title: String? // movie icin title
    let profilePath: String?
    let posterPath: String?
    let mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case castId = "cast_id"
        case id
        case character
        case name
        case title
        case profilePath = "profile_path"
        case posterPath = "poster_path"
        case mediaType = "media_type"
    }
}
