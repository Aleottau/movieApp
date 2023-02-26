//
//  MoviesRepositoryTests.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 25/11/22.
//

import XCTest
import Alamofire
@testable import inhouseApp1

final class MoviesRepositoryTests: XCTestCase {

    var networkManagerMock: NetworkManagerMock!
    var MovieListEP: MovieListEndPoint.Type!
    var fileManagerMock: FileManagerMock!
    var dataManagerMock: DataManagerMock!
    var moviesRepository: MoviesRepository!
    override func setUp() {
        networkManagerMock = NetworkManagerMock()
        MovieListEP = MovieListEndPoint.self
        fileManagerMock = FileManagerMock()
        dataManagerMock = DataManagerMock()
        moviesRepository = MoviesRepository(networkManager: networkManagerMock, endPoints: MovieListEP, fileManager: fileManagerMock, dataManager: dataManagerMock)
    }
    // MARK: - Details image tests
    func testFetchDetailPosterWithDropPathSuccess() {
        // Given
        let expectation =  expectation(description: "fetch detail poster success expectation")
        let topMovie = TopMovieDetail(originalTitle: "hola", voteAverage: 10.0, status: "hola", backDropPath: "hola", voteCount: 10, id: 1)
        dataManagerMock.processDataImageBool = true
            // Then
        moviesRepository.fetchDetailPoster(movie: topMovie) { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataImageWasCalled ?? false)
                XCTAssertTrue(self?.fileManagerMock.saveImageFromDetailsWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    
    func testFetchDetailWithImageLocalSuccess() {
        // Given
        let expectation =  expectation(description: "fetch detail poster success expectation")
        fileManagerMock.getDetailImageBool = true
        let topMovie = TopMovieDetail(originalTitle: "hola", voteAverage: 10.0, status: "hola", backDropPath: nil, voteCount: 10, id: 1)
        // Then
        moviesRepository.fetchDetailPoster(movie: topMovie) { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.fileManagerMock.getDetailsImageWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }

    func testFetchDetailPosterFailure() {
        // Given
        let expectation = self.expectation(description: "fetch detail poster failure expectation")
        networkManagerMock.expectedError = .noData
        let topMovie = TopMovieDetail(originalTitle: "hola", voteAverage: 10.0, status: "hola", backDropPath: nil, voteCount: 10, id: 1)
        // Then
        moviesRepository.fetchDetailPoster(movie: topMovie) { [weak self] result in
            switch result {
                // Expect
            case .failure:
                XCTAssertFalse(self?.networkManagerMock.getWascalled ?? true)
                expectation.fulfill()
            default:
                XCTFail("Failure is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    // MARK: - Home image tests
    func testFetchMoviePosterWithImageLocalSuccess() {
        // Given
        let movie = Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        let expectation = self.expectation(description: "fetch home image poster success expectation")
        fileManagerMock.getHomeImageBool = true
        
        // Then
        moviesRepository.fetchMoviePoster(movie: movie) { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.fileManagerMock.getHomeImageWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expect in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }

    func testFetchMoviePosterWithPosterPathSuccess() {
        // Given
        let movie = Movie(id: 1, title: nil, posterPath: "hola", mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        let expectation = self.expectation(description: "fetch home image poster success expectation")
        dataManagerMock.processDataImageBool = true
        // Then
        moviesRepository.fetchMoviePoster(movie: movie) { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataImageWasCalled ?? false)
                XCTAssertTrue(self?.fileManagerMock.saveImageFromHomeWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expect in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }

    func testFetchMoviePosterFailure() {
        // Given
        let expectation = self.expectation(description: "fetch home poster failure expectation")
        let movie = Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        // Then
        moviesRepository.fetchMoviePoster(movie: movie) { [weak self] result in
            switch result {
                // Expect
            case .failure(_):
                XCTAssertFalse(self?.networkManagerMock.getWascalled ?? true)
                expectation.fulfill()
            default:
                XCTFail("Failure is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }

    // MARK: - fetch movie data test
    func testFetchMovieSuccess() {
        // Given
        dataManagerMock.processDataMovieDetailBool = true
        let expectation = self.expectation(description: "fetch movie detail success expectation")
        // Then
        moviesRepository.fetchMovie(id: 1) { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataMovieDetailWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testFetchMovieNetworkFailure() {
        // Given
        let expectation = self.expectation(description: "fetch movie detail failure expectation")
        networkManagerMock.expectedError = .apiError
        // Then
        moviesRepository.fetchMovie(id: 1) { [weak self] result in
            switch result {
                // Expect
            case .failure(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("failure is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testFetchMovieProcessDataFailure() {
        // Given
        let expectation = self.expectation(description: "fetch movie detail failure expectation")
        // Then
        moviesRepository.fetchMovie(id: 1) { [weak self] result in
            switch result {
                // Expect
            case .failure(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataMovieDetailWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("failure is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    // MARK: - fetch home Movies data tests
    func testFetchMoviesWithProcessDataSuccess() {
        // Given
        let expectation = self.expectation(description: "fetch movies success expectation")
        dataManagerMock.processDataTrendingBool = true
        // Then
        moviesRepository.fetchMovies { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataTrendingWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success in expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testFetchMoviesWithoutProcessDataSuccess() {
        // Given
        let expectation = self.expectation(description: "fetch movies success expectation")
        // Then
        moviesRepository.fetchMovies { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataTrendingWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success in expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testFetchMoviesFailure() {
        // Given
        let expectation = self.expectation(description: "fetch movies failure expectation")
        networkManagerMock.expectedError = .apiError
        // Then
        moviesRepository.fetchMovies { [weak self] result in
            switch result {
                // EXpect
            case .failure(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Failure is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    // MARK: - fetch search movie tests
    func testSearchMovieWithProcessDataSuccess() {
        // Given
        let expectation = self.expectation(description: "fetch search movie success expectation")
        dataManagerMock.processDataSearchBool = true
        // Then
        moviesRepository.searchMovie(query: "hola") { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataSearchWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testSearchMovieWithoutProcessDataSuccess() {
        // Given
        let expectation = self.expectation(description: "fetch search movie success expectation")
        // Then
        moviesRepository.searchMovie(query: "hola") { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                XCTAssertTrue(self?.dataManagerMock.processDataSearchWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testSearchMovieFailure() {
        // Given
        let expectation = self.expectation(description: "fetch search movie failure expectation")
        networkManagerMock.expectedError = .apiError
        // Then
        moviesRepository.searchMovie(query: "hola") { [weak self] result in
            switch result {
                // EXpect
            case .failure(_):
                XCTAssertTrue(self?.networkManagerMock.getWascalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Failure is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
}
