//
//  SectionModel.swift
//  inhouseApp1
//
//  Created by alejandro on 6/09/22.
//

import Foundation
struct SectionModel {
    let items: [MovieDetailItem]
}
extension SectionModel {
    init(movie: MovieDetailModel) {
        self.init(items: [
            TopMovieDetail(movie: movie),
            MidMovieDetail(movie: movie),
            BotMovieDetail(movie: movie)
        ])
    }
}
