//
//  Person.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 12.09.2025.
//

import Foundation

struct PersonResponse: Decodable {
    let page: Int
    let results: [Person]
}

struct Person: Decodable {
    let name: String
    let knownForDepartment: String
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case name
        case knownForDepartment = "known_for_department"
        case posterPath = "poster_path"
    }
}
