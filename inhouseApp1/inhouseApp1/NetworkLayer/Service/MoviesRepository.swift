//
//  MovieService.swift
//  inhouseApp1
//
//  Created by alejandro on 17/07/22.
//

import Foundation
import Alamofire
// resul array
protocol MovieRepositoryProtocol {
    typealias Movies = (Result<[Movie], MovieError>) -> Void
    typealias MovieDetail = (Result<MovieDetailModel, MovieError>) -> Void
    typealias MoviePoster = (Result<UIImage,MoviesRepositoryError>) -> Void
    typealias DetailPoster = (Result<UIImage,MoviesRepositoryError>) -> Void
    typealias Search = (Result<[Movie], MovieError>) -> Void
    func fetchMovies(completion: @escaping  Movies)
    func fetchMovie(id: Int, completion: @escaping MovieDetail)
    func searchMovie(query: String, completion: @escaping Search)
    func fetchMoviePoster(movie: Movie, completion: @escaping MoviePoster)
    func fetchDetailPoster(movie: TopMovieDetail, completion: @escaping DetailPoster)
    func fetchTopRated(completion: @escaping  Movies)
    func fetchPopular(completion: @escaping  Movies)
}

enum MoviesRepositoryError: Error {
    case noPosterPath
    case networkFail
}

class MoviesRepository {
    private let networkManager: NetworkProtocol
    private let endPoints: MovieListEndPoint.Type
    let dataManager: DataManagerProtocol
    let fileManager: LocalFileManagerProtocol
    init(
        networkManager: NetworkProtocol,
        endPoints: MovieListEndPoint.Type,
        fileManager: LocalFileManagerProtocol,
        dataManager: DataManagerProtocol
    ) {
        self.networkManager = networkManager
        self.endPoints = endPoints
        self.fileManager = fileManager
        self.dataManager = dataManager
    }
}

extension MoviesRepository: MovieRepositoryProtocol {
    // MARK: - Details
    func fetchDetailPoster(movie: TopMovieDetail, completion: @escaping DetailPoster) {
        if let imageFromLocalFile = fileManager.getDetailsImage(imageNameId: movie.id.description) {
            completion(.success(imageFromLocalFile))
        } else if let backDropPath = movie.backDropPath {
            networkManager.get(endPoint: endPoints.images(image: backDropPath)) { [weak self] data, _ in
                if let image = self?.dataManager.processDataImage(data: data) {
                    self?.fileManager.saveImageFromDetails(image: image, imageNameId: movie.id.description)
                    completion(.success(image))
                } else if let image = UIImage(systemName: "wifi.exclamationmark") {
                    completion(.success(image))
                } else {
                    completion(.failure(.networkFail))
                }
            }
        } else {
            completion(.failure(.noPosterPath))
        }
    }
    // home fetch image
    func fetchMoviePoster(movie: Movie, completion: @escaping MoviePoster) {
        //  --------
        if let imageFromLocalFile = fileManager.getHomeImage(imageNameId: movie.id.description) {
            completion(.success(imageFromLocalFile))
        } else if let posterPath = movie.posterPath {
            networkManager.get(endPoint: endPoints.images(image: posterPath)) { [weak self] data, _ in
                if let image = self?.dataManager.processDataImage(data: data) {
                    self?.fileManager.saveImageFromHome(image: image, imageNameId: movie.id.description)
                    completion(.success(image))
                } else if let image = UIImage(systemName: "wifi.exclamationmark") {
                    completion(.success(image))
                } else {
                    completion(.failure(.networkFail))
                }
            }
        } else {
            completion(.failure(.noPosterPath))
        }
    }
    func fetchMovie(id: Int, completion: @escaping MovieDetail) {
        networkManager.get(endPoint: endPoints.movie(id: id)) { [weak self] data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let movieData = self?.dataManager.processDataMovieDetail(data: data) else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(movieData))
            }
        }
    }
   // MARK: - Home
    func fetchMovies(completion: @escaping Movies) {
        networkManager.get(endPoint: endPoints.trending(mediaType: .movie,
                                                        timeWindow: .week)) { [weak self] data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let trendingData = self?.dataManager.processDataTrending(data: data)
                completion(.success(trendingData?.results ?? []))
            }
        }
    }
    func fetchTopRated(completion: @escaping Movies) {
        networkManager.get(endPoint: endPoints.topRated) { [weak self] data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let moviesData = self?.dataManager.processDataTrending(data: data) else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(moviesData.results))
            }
        }
    }

    func fetchPopular(completion: @escaping Movies) {
        networkManager.get(endPoint: endPoints.popular) { [weak self] data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let moviesData = self?.dataManager.processDataTrending(data: data) else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(moviesData.results))
            }
        }
    }
    // MARK: - Search
    func searchMovie(query: String, completion: @escaping Search) {
        networkManager.get(endPoint: endPoints.search(query: query)) { [weak self] data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let searchDataStruct = self?.dataManager.processDataSearch(data: data)
                completion(.success(searchDataStruct?.results ?? []))
            }
        }
    }
}
