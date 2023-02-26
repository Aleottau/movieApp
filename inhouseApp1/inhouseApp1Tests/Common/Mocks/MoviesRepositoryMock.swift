//
//  MoviesRepositoryMock.swift
//  inhouseApp1Tests
//
//  Created by Jorge Palacio on 14/11/22.
//

import Foundation
@testable import inhouseApp1

class MoviesRepositoryMock: MovieRepositoryProtocol {
    
    func fetchDetailPoster(movie: inhouseApp1.TopMovieDetail, completion: @escaping DetailPoster) {
    }
    

    var expectedError: MovieError?

    var fetchMoviesWasCalled = false
    func fetchMovies(completion: @escaping Trending) {
        fetchMoviesWasCalled = true
        if let error = expectedError {
            completion(.failure(error))
        } else {
            completion(.success([]))
        }
    }
    var fetchMovieWasCalled = false
    func fetchMovie(id: Int, completion: @escaping MovieDetail) {
        fetchMovieWasCalled = true
        if let error = expectedError {
            completion(.failure(error))
        } else {
            completion(.success(MovieDetailModel(adult: true, backDropPath: nil, budget: nil, belongsToCollection: nil, genres: [], homepage: nil, id: 1, originalLanguage: "", originalTitle: "", overview: nil, popularity: 1.0, posterPath: nil, productionCompanies: [], productionCountries: [], releaseDate: "", revenue: 1, runtime: nil, spokenLanguages: [], status: "", title: "", tagline: nil, voteAverage: 1.0, voteCount: 1)))
        }
    }
    var searchMovieWasCalled = false
    func searchMovie(query: String, completion: @escaping Search) {
        searchMovieWasCalled = true
        if let error = expectedError {
            completion(.failure(error))
        } else {
            completion(.success([]))
        }
    }
    var fetchMoviePosterWasCalled = false
    func fetchMoviePoster(movie: inhouseApp1.Movie, completion: @escaping MoviePoster) {
        fetchMoviePosterWasCalled = true
    }
}
