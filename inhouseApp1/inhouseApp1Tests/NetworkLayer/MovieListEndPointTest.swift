//
//  MovieListEndPointTest.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 16/11/22.
//

import XCTest
import Alamofire
@testable import inhouseApp1

final class MovieListEndPointTest: XCTestCase {
    
    var movieListEP: MovieListEndPoint.Type!
    var mediaType: MediaType.Type!
    var timeWindow: TimeWindow.Type!
    override func setUp() {
        super.setUp()
        movieListEP = MovieListEndPoint.self
        mediaType = MediaType.self
        timeWindow = TimeWindow.self
    }
    
//    var arrayMovieListEP: [MovieListEndPoint] = [
//        .trending(mediaType: .all, timeWindow: .day),
//        .movie(id: 10),
//        .images(image: "hola")
//    ]
    
    func testMLEPdescription() {
        // Given
        let expectTrending = "Trending"
        let expectMovie = "Movies"
        let expectSearch = "Search Movie"
        let expectImages = "Movie image"
                
        // Then
        let resultCaseTrending = movieListEP.trending(mediaType: .all, timeWindow: .day).description
        let resultCaseMovie = movieListEP.movie(id: 24).description
        let resultCaseSearch = movieListEP.search(query: "godOfWar").description
        let resultCaseImages = movieListEP.images(image: "godOfWar").description

        // Expect
        XCTAssertEqual(resultCaseTrending, expectTrending)
        XCTAssertEqual(resultCaseMovie, expectMovie)
        XCTAssertEqual(resultCaseSearch, expectSearch)
        XCTAssertEqual(resultCaseImages, expectImages)
    }
    
    func testMLEPparameters() {
        // Given
        let key = "api_key"
        let expectTrendingAndMovieValue = "5bae4b813f03cae515380880bcd7600f"
        let expectImageValue: String? = nil
        let expectSearchValue = "godOfWar"
        // result from original enum
        let resultCaseTrending = movieListEP.trending(mediaType: .all, timeWindow: .day).parameters
        let resultCaseMovie = movieListEP.movie(id: 24).parameters
        let resultCaseImages = movieListEP.images(image: "godOfWar").parameters
        let queryKey = "query"
        let resultCaseSearch = movieListEP.search(query: "godOfWar").parameters
        // Then
        // Case trending
        let resultForTrending = getResultForParametersTest(key: key, resultCase: resultCaseTrending)
        // Case movie
        let resultForMovie = getResultForParametersTest(key: key, resultCase: resultCaseMovie)
        // Case images
        guard let resultCaseImages = resultCaseImages?[key] else {
            return
        }
        guard let resultForImages = resultCaseImages as? String else {
            return
        }
        // Case search
        let resultForSearch = getResultForParametersTest(key: queryKey, resultCase: resultCaseSearch)
        // Expect
        XCTAssertEqual(resultForTrending, expectTrendingAndMovieValue)
        XCTAssertEqual(resultForMovie, expectTrendingAndMovieValue)
        XCTAssertEqual(resultForImages, expectImageValue)
        XCTAssertEqual(resultForSearch, expectSearchValue)
    }
    func getResultForParametersTest(key: String, resultCase: [String: Any]?) -> String {
        guard let ValueForKey = resultCase?[key] else {
            XCTFail("Value for key not found")
            return "nil"
        }
        guard let stringValue = ValueForKey as? String else {
            XCTFail("value is not a string")
            return "nil"
        }
        return stringValue
    }
    
    func testMLEPrequestUrl() {
        // Given
        let expectImageUrl = URL(string: "https://image.tmdb.org/t/p/original")?.appendingPathComponent("godOfWar")
        let expectTrendingUrl = URL(string: "https://api.themoviedb.org/3")?.appendingPathComponent("/trending/\(mediaType.all)/\(timeWindow.day)")
        // result from original enum
        let resultCaseImage = movieListEP.images(image: "godOfWar").requestUrl
        let resultCaseTrending = movieListEP.trending(mediaType: .all, timeWindow: .day).requestUrl
        // Then
        guard let expectImageUrl = expectImageUrl else {
            return
        }
        guard let expectTrendingUrl = expectTrendingUrl else {
            return
        }
        // Expect
        XCTAssertEqual(resultCaseImage, expectImageUrl)
        XCTAssertEqual(resultCaseTrending, expectTrendingUrl)
    }
    
    func testMLEPath() {
        // Given
        let expectTrendingPath = "/trending/\(mediaType.all)/\(timeWindow.day)"
        let expectMoviePath = "/movie/\(24)"
        let expectSearchPath = "/search/movie"
        let expectImagePath = "/godOfWar"
        
        // Then
        let resultCaseTrending = movieListEP.trending(mediaType: .all, timeWindow: .day).path
        let resultCaseMovie = movieListEP.movie(id: 24).path
        let resultCaseSearch = movieListEP.search(query: "godOfWar").path
        let resultCaseImage = movieListEP.images(image: "godOfWar").path
        // Expect
        XCTAssertEqual(resultCaseTrending, expectTrendingPath)
        XCTAssertEqual(resultCaseMovie, expectMoviePath)
        XCTAssertEqual(resultCaseSearch, expectSearchPath)
        XCTAssertEqual(resultCaseImage, expectImagePath)
    }
    
    func testMLEmethod() {
        // Given
        let expectDefaultMethod: HTTPMethod = .get
        // Then
        let resultCaseTrending = movieListEP.trending(mediaType: .all, timeWindow: .day).method
        let resultCaseMovie = movieListEP.movie(id: 24).method
        let resultCaseSearch = movieListEP.search(query: "godOfWar").method
        let resultCaseImage = movieListEP.images(image: "godOfWar").method
        // Expect
        XCTAssertEqual(resultCaseTrending, expectDefaultMethod)
        XCTAssertEqual(resultCaseMovie, expectDefaultMethod)
        XCTAssertEqual(resultCaseSearch, expectDefaultMethod)
        XCTAssertEqual(resultCaseImage, expectDefaultMethod)
    }
}
