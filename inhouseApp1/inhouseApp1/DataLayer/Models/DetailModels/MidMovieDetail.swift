//
//  MidMovieDetail.swift
//  inhouseApp1
//
//  Created by alejandro on 7/09/22.
//

import Foundation

struct MidMovieDetail {
    let genres: [GenreMovie]
}
extension MidMovieDetail {
    init(movie: MovieDetailModel) {
        self.init(genres: movie.genres)
    }
}
extension MidMovieDetail: MovieDetailItem {}
