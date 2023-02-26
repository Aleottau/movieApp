//
//  DataManagerTests.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 17/11/22.
//

import XCTest
@testable import inhouseApp1

final class DataManagerTests: XCTestCase {
    
    var dataManager: DataManagerProtocol!
    override func setUp() {
        super.setUp()
        dataManager = DataManager()
    }
    
    func testProcessDataMovieDetailSuccess() {
        // Given
        let data = getData(with: "MovieDetailModel.json")
        // Then
        guard let modelFromManager = dataManager.processDataMovieDetail(data: data) else {
            XCTFail("dataFromManager is nil")
            return
        }
        // Expect
        XCTAssertEqual(modelFromManager.id, 361743)
    }
    
    func testProcessDataMovieDetailFailure() {
        // Given Then
        let modelFromManager = dataManager.processDataMovieDetail(data: Data())
        // Expect
        XCTAssertNil(modelFromManager)
    }
    
    func testProcessDataTrendingSuccess() {
        // Given
        let data = getData(with: "TrendingModel.json")
        // Then
        let modelFromManager = dataManager.processDataTrending(data: data)
        // Expect
        XCTAssertNotNil(modelFromManager)
    }
    
    func testProcessDataTrendingFailure() {
        // Given Then
        let modelFromManager = dataManager.processDataTrending(data: Data())
        // Expect
        XCTAssertNil(modelFromManager)
    }
    
    func testProcessDataSearchSuccess() {
        // Given
        let data = getData(with: "TrendingModel.json")
        // Then
        let modelFromManager = dataManager.processDataSearch(data: data)
        // Expect
        XCTAssertNotNil(modelFromManager)
    }
    
    func testProcessDataSearchFailure() {
        // Given Then
        let modelFromManager = dataManager.processDataSearch(data: Data())
        XCTAssertNil(modelFromManager)
    }
    
    func testProcessDataImageSuccess() {
        // Given
        let data = getData(with: "strangerThings.jpg")
        // Then
        let imageFromManager = dataManager.processDataImage(data: data)
        // Expect
        XCTAssertNotNil(imageFromManager)
    }
    
    func testProcessDataImageFailure() {
        // Given Then
        let imageFromManager = dataManager.processDataImage(data: Data())
        // Expect
        XCTAssertNil(imageFromManager)
    }
    
    func getData(with filePath: String) -> Data {
        guard let bundle = Bundle(for: self.classForCoder).resourceURL?.appendingPathComponent(filePath) else {
            return Data()
        }
        let url = URL(fileURLWithPath: bundle.path)
        guard let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }
}
