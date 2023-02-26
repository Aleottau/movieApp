//
//  MoviesInteractor.swift
//  inhouseApp1
//
//  Created by alejandro on 20/09/22.
//

import Foundation
import UIKit
import CoreData

protocol MoviesInteractorProtocol {
    typealias Movies = (Result<[Movie],MovieError>) -> Void
    func loadHomeTrending(completion: @escaping Movies)
    func loadMovieDetails(with movie: Movie, completion: @escaping (Result<MovieDetailModel,Error>) -> Void)
    func loadPosterDetails(with movie: Movie,
                           completion: @escaping (Result<UIImage,MoviesRepositoryError>) -> Void)
    func loadSearch(with query: String, completion: @escaping Movies)
    func registerNotification()
    func loadHomeMovies(
        trendingCallback: @escaping Movies,
        topRatedCallback: @escaping Movies,
        popularCallback: @escaping Movies
    )
}

class MoviesInteractor {
    let dataBaseManager: DataBaseManagerProtocol
    let movieRepository: MovieRepositoryProtocol
    let notificationManager: NotificationManagerProtocol
    init(
        dataBaseManager: DataBaseManagerProtocol,
        movieRepository: MovieRepositoryProtocol,
        notificationManager: NotificationManagerProtocol
    ) {
        self.movieRepository = movieRepository
        self.dataBaseManager = dataBaseManager
        self.notificationManager = notificationManager
    }
}

extension MoviesInteractor: MoviesInteractorProtocol {
    func registerNotification() {
        notificationManager.registerRemoteNot()
    }

    // MARK: - SEARCH
    func loadSearch(with query: String, completion: @escaping (Result<[Movie], MovieError>) -> Void) {
        movieRepository.searchMovie(query: query) { [weak self] result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                self?.dataBaseManager.searchMovieByName(query: query, completion: { movies in
                    if movies.isEmpty {
                        completion(.failure(error))
                    } else {
                        completion(.success(movies))
                    }
                })
            }
        }
    }

    // MARK: - DETAILS
    func loadPosterDetails(with movie: Movie,
                           completion: @escaping (Result<UIImage,MoviesRepositoryError>) -> Void) {
        movieRepository.fetchMoviePoster(movie: movie, completion: completion)
    }

    func loadMovieDetails(with movie: Movie,
                          completion: @escaping (Result<MovieDetailModel, Error>) -> Void) {
        movieRepository.fetchMovie(id: movie.id) { [weak self] result in
            switch result {
            case .success(let movieDetail):
                self?.dataBaseManager.saveDetailObject(movieDetail: movieDetail)
                completion(.success(movieDetail))
            case .failure:
                self?.dataBaseManager.getMovieDetail(movieId: movie.id, completion: { result in
                    switch result {
                    case .success(let movie):
                        completion(.success(movie))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            }
        }
    }

    // MARK: - HOME
    func loadHomeTrending(completion: @escaping (Result<[Movie],MovieError>) -> Void) {
        movieRepository.fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.dataBaseManager.saveMovieObject(movies: movies)
                completion(.success(movies))
            case .failure(let error):
                self?.dataBaseManager.getAllMovies(completion: { movies in
                    if movies.isEmpty {
                        completion(.failure(error))
                    } else {
                        completion(.success(movies))
                    }
                })
            }
        }
    }
    func loadHomeMovies(
        trendingCallback: @escaping Movies,
        topRatedCallback: @escaping Movies,
        popularCallback: @escaping Movies
    ) {
        movieRepository
        .fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.dataBaseManager.saveMovieObject(movies: movies)
                trendingCallback(.success(movies))
            case .failure(let error):
                self?.dataBaseManager.getAllMovies(completion: { movies in
                    if movies.isEmpty {
                        trendingCallback(.failure(error))
                    } else {
                        trendingCallback(.success(movies))
                    }
                })
            }
        }
        movieRepository
        .fetchTopRated { [weak self] result in
            switch result {
            case .success(let movies):
                self?.dataBaseManager.saveMovieObject(movies: movies)
                topRatedCallback(.success(movies))
            case .failure(let error):
                self?.dataBaseManager.getAllMovies(completion: { movies in
                    if movies.isEmpty {
                        topRatedCallback(.failure(error))
                    } else {
                        topRatedCallback(.success(movies))
                    }
                })
            }
        }
        movieRepository
        .fetchPopular { [weak self] result in
            switch result {
            case .success(let movies):
                self?.dataBaseManager.saveMovieObject(movies: movies)
                popularCallback(.success(movies))
            case .failure(let error):
                self?.dataBaseManager.getAllMovies(completion: { movies in
                    if movies.isEmpty {
                        popularCallback(.failure(error))
                    } else {
                        popularCallback(.success(movies))
                    }
                })
            }
        }
    }
}
