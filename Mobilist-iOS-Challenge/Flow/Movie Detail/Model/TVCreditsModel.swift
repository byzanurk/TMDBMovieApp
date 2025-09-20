//  TVCreditsModel.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import Foundation

struct TVCreditsResponse: Decodable {
    let id: Int
    let cast: [Cast]
}
