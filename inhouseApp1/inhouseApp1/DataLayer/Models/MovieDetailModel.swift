//
//  MovieModel.swift
//  inhouseApp1
//
//  Created by alejandro on 20/07/22.
//

import Foundation

struct MovieDetailModel: Codable {
    let adult: Bool
    let backDropPath: String?
    let budget: Int?
    let belongsToCollection: BelongsToCollection?
    let genres: [GenreMovie]
    let homepage: String?
    let id: Int
    let originalLanguage, originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguages]
    let status, title: String
    let tagline: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult, genres, homepage, id, budget, revenue
        case backDropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
        case runtime, status, title, tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath: String?
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
    }
}
struct GenreMovie: Codable {
    let name: String
}
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
struct ProductionCountry: Codable {
    let iso3166, name: String
    enum CodingKeys: String, CodingKey {
        case iso3166 = "iso_3166_1"
        case name
    }
}
struct SpokenLanguages: Codable {
    let englishName, iso639, name: String
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639 = "iso_639_1"
        case name
    }
}

extension MovieDetailModel {
    init(need movie: MovieDetailCoreData) {
        let genresMovie = movie.genres.map { GenreMovie(name: $0.name) }
        self.init(adult: false,
                  backDropPath: nil,
                  budget: Int(movie.budget),
                  belongsToCollection: nil,
                  genres: genresMovie,
                  homepage: movie.homepage,
                  id: Int(movie.movieCDid),
                  originalLanguage: "nil",
                  originalTitle: movie.originalTitle,
                  overview: movie.overview,
                  popularity: 0.0,
                  posterPath: nil,
                  productionCompanies: [],
                  productionCountries: [],
                  releaseDate: movie.releaseDate,
                  revenue: Int(movie.revenue),
                  runtime: Int(movie.runtime),
                  spokenLanguages: [],
                  status: movie.status,
                  title: "nil",
                  tagline: nil,
                  voteAverage: Double(truncating: movie.voteAverage),
                  voteCount: Int(movie.voteCount)
        )
    }
}
