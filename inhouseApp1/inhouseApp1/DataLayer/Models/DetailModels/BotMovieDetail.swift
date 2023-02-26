//
//  BotMovieModel.swift
//  inhouseApp1
//
//  Created by alejandro on 5/09/22.
//

import Foundation
struct BotMovieDetail {
    let overview: String?
    let releaseDate: String
    let runtime: Int?
    let budget: Int?
    let revenue: Int
    let homepage: String?
}
extension BotMovieDetail {
    init(movie: MovieDetailModel) {
        self.init(
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            runtime: movie.runtime,
            budget: movie.budget,
            revenue: movie.revenue,
            homepage:  movie.homepage
        )
    }
}
extension BotMovieDetail: MovieDetailItem {}
