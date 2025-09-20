//
//  TV.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 12.09.2025.
//

import Foundation

struct TVShowResponse: Decodable {
    let page: Int
    let results: [TVShow]
}

struct TVShow: Decodable {
    let name: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case name
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
