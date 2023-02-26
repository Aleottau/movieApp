//
//  MovieErrorTests.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 16/11/22.
//

import XCTest
@testable import inhouseApp1

final class MovieErrorTests: XCTestCase {
    var movieError: MovieError.Type!

    override func setUp() {
        super.setUp()
        movieError = MovieError.self
    }

    func testlocalizedDescription() {
        // Given
        let expectApiErrorValue = "Failed to fecth data"
        let expectInvalidEndPointValue = "Invalid endpoint"
        let expectInvalidResponseValue = "Invalid response"
        let expectNoDataValue = "No data"
        let expectSerializationErrorValue = "Failed to decode"
        
        // Then
        let resultCaseApiError = movieError.apiError.localizedDescription
        let resultCaseInvalidEndPoint = movieError.invalidEndPoint.localizedDescription
        let resultCaseInvalidResponse = movieError.invalidResponse.localizedDescription
        let resultCaseNoData = movieError.noData.localizedDescription
        let resultCaseSerializationError = movieError.serializationError.localizedDescription
        // Expect
        XCTAssertEqual(resultCaseApiError, expectApiErrorValue)
        XCTAssertEqual(resultCaseInvalidEndPoint, expectInvalidEndPointValue)
        XCTAssertEqual(resultCaseInvalidResponse, expectInvalidResponseValue)
        XCTAssertEqual(resultCaseNoData, expectNoDataValue)
        XCTAssertEqual(resultCaseSerializationError, expectSerializationErrorValue)
    }
}
