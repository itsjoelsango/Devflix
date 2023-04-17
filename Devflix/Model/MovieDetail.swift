//
//  MovieDetail.swift
//  Devflix
//
//  Created by Jo Michael on 4/8/23.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let originalTitle: String
    let title: String
    let description: String
    let releasedDate: String
    let originalLanguage: String
    let imageURL: String
    let backdropImage: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case title
        case description = "overview"
        case releasedDate = "release_date"
        case originalLanguage = "original_language"
        case imageURL = "poster_path"
        case backdropImage = "backdrop_path"
    }
}
