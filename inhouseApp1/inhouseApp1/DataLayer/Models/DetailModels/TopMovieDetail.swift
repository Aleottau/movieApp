//
//  TopMovieDetail.swift
//  inhouseApp1
//
//  Created by alejandro on 2/09/22.
//

import Foundation
struct TopMovieDetail {
    let originalTitle: String
    let voteAverage: Double
    let status: String
    let backDropPath: String?
    let voteCount: Int
    let id: Int

}
extension TopMovieDetail {
    init(movie: MovieDetailModel) {
        self.init(
            originalTitle: movie.originalTitle,
            voteAverage: movie.voteAverage,
            status: movie.status,
            backDropPath: movie.backDropPath,
            voteCount: movie.voteCount,
            id: movie.id
        )
    }
}
extension TopMovieDetail: MovieDetailItem {}
