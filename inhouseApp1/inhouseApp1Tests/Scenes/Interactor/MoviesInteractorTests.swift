//
//  MoviesInteractorTests.swift
//  inhouseApp1Tests
//
//  Created by Jorge Palacio on 14/11/22.
//

import XCTest
@testable import inhouseApp1

final class MoviesInteractorTests: XCTestCase {
    var dbManagerMock: DatabaseManagerMock!
    var interactor: MoviesInteractor!
    var notManagerMock: NotificationManagerMock!
    var repositoryMock: MoviesRepositoryMock!

    override func setUp() {
        super.setUp()
        dbManagerMock = DatabaseManagerMock()
        notManagerMock = NotificationManagerMock()
        repositoryMock = MoviesRepositoryMock()
        interactor = MoviesInteractor(
            dataBaseManager: dbManagerMock,
            movieRepository: repositoryMock,
            notificationManager: notManagerMock
        )
    }
    // MARK: - Home
    func testLoadHomeTrendingSuccess() {
        // Given
        let expectation = self.expectation(description: "Load home success expectation")

        // Then
        interactor.loadHomeTrending { [weak self] result in
            switch result {
                // Expect
            case .success:
                XCTAssertTrue(self?.dbManagerMock.saveMovieObjectCalled ?? false)
                XCTAssertTrue(self?.repositoryMock.fetchMoviesWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testLoadHomeTrendingNoEmptySuccess() {
        // Given
        let expectation = self.expectation(description: "Load home success expectation")
        repositoryMock.expectedError = .apiError
        dbManagerMock.getAllMoviesBool = true

        // Then
        interactor.loadHomeTrending { [weak self] result in
            switch result {
                // Expect
            case .success:
                XCTAssertTrue(self?.dbManagerMock.getAllMoviesCalled ?? false)
                XCTAssertTrue(self?.repositoryMock.fetchMoviesWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Failure is expected in this test")
            }
        }

        waitForExpectations(timeout: 5.0)
    }
    func testLoadHomeTrendingFailure() {
        // Given
        let expectation = self.expectation(description: "Load home failure expectation")
        repositoryMock.expectedError = .apiError

        // Then
        interactor.loadHomeTrending { [weak self] result in
            switch result {
                // Expect
            case .failure:
                XCTAssertTrue(self?.dbManagerMock.getAllMoviesCalled ?? false)
                XCTAssertTrue(self?.repositoryMock.fetchMoviesWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Failure is expected in this test")
            }
        }

        waitForExpectations(timeout: 5.0)
    }
    // MARK: - Details
    func testLoadMovieDetailsSuccess() {
        // Given
        let expectation = self.expectation(description: "load movie details success expectation")
        let movie = Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        // Then
        interactor.loadMovieDetails(with: movie) { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.repositoryMock.fetchMovieWasCalled ?? false)
                XCTAssertTrue(self?.dbManagerMock.saveDetailObjectWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testLoadMovieDetailsDBSuccess() {
        // Given
        let expectation = self.expectation(description: "load movie details db success expectation")
        let movie = Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        repositoryMock.expectedError = .apiError
        // Then
        interactor.loadMovieDetails(with: movie) { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.repositoryMock.fetchMovieWasCalled ?? false)
                XCTAssertTrue(self?.dbManagerMock.getMovieDetailWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("Success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testLoadMovieDetailsFailure() {
        // Given
        let expectation = self.expectation(description: "load movie ")
        let movie = Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        repositoryMock.expectedError = .apiError
        dbManagerMock.expectError = .noData
        // Then
        interactor.loadMovieDetails(with: movie) { [weak self] result in
            switch result {
                // Expect
            case .failure(_):
                XCTAssertTrue(self?.repositoryMock.fetchMovieWasCalled ?? false)
                XCTAssertTrue(self?.dbManagerMock.getMovieDetailWasCalled ?? true)
                expectation.fulfill()
            default:
                XCTFail("Failure is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testLoadPosterDetails() {
        // Given
        let movie = Movie(id: 1, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        // Then
        interactor.loadPosterDetails(with: movie) { [weak self] result in
            XCTAssertTrue(self?.repositoryMock.fetchMoviePosterWasCalled ?? false)
        }
    }
    // MARK: - search
    func testLoadSearchSuccess() {
        // Given
        let expectation = self.expectation(description: "load search success expectation")
        // Then
        interactor.loadSearch(with: "hola") { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.repositoryMock.searchMovieWasCalled ?? false)
                expectation.fulfill()
            default:
                XCTFail("success is expected in this test")
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testLoadSearchDBSuccess() {
        // Given
        let expectation = self.expectation(description: "load search success expectation")
        repositoryMock.expectedError = .noData
        dbManagerMock.searchMovieByNameBool = true
        // Then
        interactor.loadSearch(with: "hola") { [weak self] result in
            switch result {
                // Expect
            case .success(_):
                XCTAssertTrue(self?.repositoryMock.searchMovieWasCalled ?? false)
                XCTAssertTrue(self?.dbManagerMock.searchMovieByNameWasCalled ?? false)
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    func testLoadSearchFailure() {
        // Given
        let expectation = self.expectation(description: "load search from data base failure expectation")
        repositoryMock.expectedError = .apiError
        // Then
        interactor.loadSearch(with: "hola") { [weak self] result in
            switch result {
                // Expect
            case .failure(_):
                XCTAssertTrue(self?.repositoryMock.searchMovieWasCalled ?? false)
                XCTAssertTrue(self?.dbManagerMock.searchMovieByNameWasCalled ?? false)
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    
}
