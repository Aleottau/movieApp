//
//  DatabaseManagerMock.swift
//  inhouseApp1Tests
//
//  Created by Jorge Palacio on 14/11/22.
//

import CoreData
import Foundation
@testable import inhouseApp1

class DatabaseManagerMock: DataBaseManagerProtocol {
    static var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "MovieDb")
        return container
    }

    func getContext() -> NSManagedObjectContext {
        return NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
    }

    func saveContext() {

    }

    var saveMovieObjectCalled = false
    func saveMovieObject(movies: [inhouseApp1.Movie]) {
        saveMovieObjectCalled = true
    }

    var getAllMoviesCalled = false
    var getAllMoviesBool = false
    func getAllMovies(completion: @escaping ([inhouseApp1.Movie]) -> Void) {
        getAllMoviesCalled = true
        completion(getAllMoviesBool ? [Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)] : [])
    }
    
    var searchMovieByNameWasCalled = false
    var searchMovieByNameBool = false
    func searchMovieByName(query: String, completion: @escaping ([inhouseApp1.Movie]) -> Void) {
        searchMovieByNameWasCalled = true
        completion(searchMovieByNameBool ? [Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)] : [])
    }
    var saveDetailObjectWasCalled = false
    func saveDetailObject(movieDetail: inhouseApp1.MovieDetailModel) {
        saveDetailObjectWasCalled = true
    }
    var expectError: MovieError?
    var getMovieDetailWasCalled = false
    func getMovieDetail(movieId: Int, completion: @escaping (Result<inhouseApp1.MovieDetailModel, Error>) -> Void) {
        getMovieDetailWasCalled = true
        if let error = expectError {
            completion(.failure(error))
        } else {
            completion(.success(MovieDetailModel(adult: true, backDropPath: nil, budget: nil, belongsToCollection: nil, genres: [], homepage: nil, id: 1, originalLanguage: "", originalTitle: "", overview: nil, popularity: 1.0, posterPath: nil, productionCompanies: [], productionCountries: [], releaseDate: "", revenue: 1, runtime: nil, spokenLanguages: [], status: "", title: "", tagline: nil, voteAverage: 1.0, voteCount: 1)))
        }
    }
}
