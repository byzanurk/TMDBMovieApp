//
//  Config.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 11.09.2025.
//

import Foundation

struct Config {
    static let tmdbApiKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["TMDB_API_KEY"] as? String else {
            fatalError("Config.plist file or TMDB_API_KEY is not find")
        }
        return apiKey
    }()
    
    static let youtubeApiKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["YOUTUBE_API_KEY"] as? String else {
            fatalError("Config.plist file or YOUTUBE_API_KEY is not find")
        }
        return apiKey
    }()
    
    enum APIBaseURL {
        static let tmdbBaseURL = "https://api.themoviedb.org/3"
        static let youtubeBaseURL = "https://www.googleapis.com/youtube/v3"
    }
}
