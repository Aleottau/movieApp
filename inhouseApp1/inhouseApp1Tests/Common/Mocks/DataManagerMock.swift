//
//  DataManagerMock.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 25/11/22.
//

import Foundation
@testable import inhouseApp1
import UIKit

class DataManagerMock: DataManagerProtocol {
    var processDataTrendingWasCalled = false
    var processDataTrendingBool = false
    func processDataTrending(data: Data) -> inhouseApp1.TrendingModel? {
        processDataTrendingWasCalled = true
        return processDataTrendingBool ? TrendingModel(results: []) : nil
    }
    var processDataMovieDetailWasCalled = false
    var processDataMovieDetailBool = false
    func processDataMovieDetail(data: Data) -> inhouseApp1.MovieDetailModel? {
        processDataMovieDetailWasCalled = true
        return processDataMovieDetailBool ? MovieDetailModel(adult: true, backDropPath: nil, budget: nil, belongsToCollection: nil, genres: [], homepage: nil, id: 1, originalLanguage: "hola", originalTitle: "hola", overview: nil, popularity: 0.0, posterPath: nil, productionCompanies: [], productionCountries: [], releaseDate: "hola", revenue: 1, runtime: nil, spokenLanguages: [], status: "hola", title: "hola", tagline: nil, voteAverage: 0.0, voteCount: 1) : nil
    }
    var processDataImageWasCalled = false
    var processDataImageBool = false
    func processDataImage(data: Data) -> UIImage? {
        processDataImageWasCalled = true
        return processDataImageBool ? UIImage() : nil
    }
    
    var processDataSearchWasCalled = false
    var processDataSearchBool = false
    func processDataSearch(data: Data) -> inhouseApp1.SearchModel? {
        processDataSearchWasCalled = true
        let search = SearchModel(results: [])
        return processDataSearchBool ? search : nil
    }
}
