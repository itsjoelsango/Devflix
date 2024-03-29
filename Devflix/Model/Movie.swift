//
//  Movie.swift
//  Devflix
//
//  Created by Jo Michael on 4/5/23.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let releasedDate: String
    let originalLanguage: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "original_title"
        case description = "overview"
        case releasedDate = "release_date"
        case originalLanguage = "original_language"
        case imageURL = "poster_path"
    }
}
