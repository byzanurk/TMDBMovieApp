//
//  PersonDetail.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 12.09.2025.
//

import Foundation

struct PersonDetailResponse: Decodable {
    let page: Int
    let results: [PersonDetail]
}

struct PersonDetail: Decodable {
    let id: Int
    let name: String
    let knownForDepartment: String
    let biography: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case knownForDepartment = "known_for_department"
        case biography
        case profilePath = "profile_path"
    }
}
