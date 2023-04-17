//
//  TVShow.swift
//  Devflix
//
//  Created by Jo Michael on 4/16/23.
//

import Foundation

struct TVShow: Codable, Identifiable {
    let id: Int
    let name: String
    let originalName: String
    let description: String
    let language: String
    let releasedYear: String
    let imageURL: String
    let backdropImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "original_name"
        case description = "overview"
        case language = "original_language"
        case releasedYear = "first_air_date"
        case imageURL = "poster_path"
        case backdropImageURL = "backdrop_path"
    }
}
