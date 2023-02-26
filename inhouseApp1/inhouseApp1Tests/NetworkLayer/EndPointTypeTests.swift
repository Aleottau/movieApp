//
//  EndPointTypeTests.swift
//  inhouseApp1Tests
//
//  Created by Jorge Palacio on 14/11/22.
//

import XCTest
import Alamofire
@testable import inhouseApp1

final class EndPointTypeTests: XCTestCase {

    struct TestEndpoint: EndPointType {
        var path: String = "TestPath"
        var method: Alamofire.HTTPMethod = .get
        var requestUrl: URL = URL(string: "https://www.google.com")!
        var parameters: [String : Any]? = nil
    }

    var endpoint: EndPointType!

    override func setUp() {
        super.setUp()
        endpoint = TestEndpoint()
    }

    func testBaseUrl() {
        // Given
        let expectedUrl = URL(string: "https://api.themoviedb.org/3")!

        // Then, expect
        XCTAssertEqual(endpoint.baseUrl, expectedUrl)
    }

    func testBaseUrlImage() {
        // Given
        let expectedUrl = URL(string: "https://image.tmdb.org/t/p/original")!

        // Then, expect
        XCTAssertEqual(endpoint.baseUrlImage, expectedUrl)
    }

    func testDictionaryBase() {
        // Given
        let key = "api_key"
        let expectedValue = "5bae4b813f03cae515380880bcd7600f"
        let dict = endpoint.dictionaryBase()

        // Then
        guard let value = dict[key] else {
            XCTFail("Value not found for key: \(key)")
            return
        }

        guard let stringValue = value as? String else {
            XCTFail("Value is not a string")
            return
        }

        // Expect
        XCTAssertEqual(stringValue, expectedValue)
    }

    func testDictionaryBaseSearch() {
        // Given
        let key = "query"
        let expectedValue = "Test marvel movie"
        let dict = endpoint.dictionaryBaseSearch(need: expectedValue)

        // Then
        guard let value = dict[key] else {
            XCTFail("Value not found for key: \(key)")
            return
        }

        guard let stringValue = value as? String else {
            XCTFail("Value is not a string")
            return
        }

        // Expect
        XCTAssertEqual(stringValue, expectedValue)
    }
}
