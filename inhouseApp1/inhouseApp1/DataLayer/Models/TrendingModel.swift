//
//  TrendingModel.swift
//  inhouseApp1
//
//  Created by alejandro on 20/07/22.
//

import Foundation

struct TrendingModel: Codable {
    let results: [Movie]
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Movie: Codable {
    let id: Int
    let title: String?
    let posterPath: String?
    let mediaType: String?
    let popularity: Double?
    let lenguage: String?
    let releaseDate: String?
    let voteAverage: Double?
    let name, originalName, firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case popularity
        case lenguage = "original_language"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
    }
}

extension Movie {
    init(need movieCoreData: MovieCoreData) {
        self.init(
            id: Int(movieCoreData.id),
            title: movieCoreData.title,
            posterPath: nil,
            mediaType: movieCoreData.mediaType,
            popularity: nil,
            lenguage: movieCoreData.lenguage,
            releaseDate: movieCoreData.releaseDate,
            voteAverage: movieCoreData.voteAverage.doubleValue,
            name: movieCoreData.name,
            originalName: nil,
            firstAirDate: nil)
    }
}
