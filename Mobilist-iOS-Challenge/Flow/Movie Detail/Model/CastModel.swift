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

struct Cast: Decodable {
    let castId: Int
    let character: String
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castId = "cast_id"
        case character
        case name
        case profilePath = "profile_path"
    }
}
