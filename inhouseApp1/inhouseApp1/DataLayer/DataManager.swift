//
//  dataLayer.swift
//  inhouseApp1
//
//  Created by alejandro on 11/07/22.
//

import Foundation
import UIKit

protocol DataManagerProtocol {
    func processDataTrending(data: Data) -> TrendingModel?
    func processDataMovieDetail(data: Data) -> MovieDetailModel?
    func processDataImage(data: Data) -> UIImage?
    func processDataSearch(data: Data) -> SearchModel?
}

class DataManager {
}

extension DataManager: DataManagerProtocol {

    // MARK: - Details
    func processDataMovieDetail(data: Data) -> MovieDetailModel? {
        do {
            let dataInfo = try  JSONDecoder().decode(
                MovieDetailModel.self,
                from: data
            )
            return dataInfo
        } catch let error {
            print("Error: \(error)")
            return nil
        }
    }
    func processDataImage(data: Data) -> UIImage? {
        return UIImage(data: data)
    }

    // MARK: - Home
    func processDataTrending(data: Data) -> TrendingModel? {
        do {
            let dataInfo = try  JSONDecoder().decode(
                TrendingModel.self,
                from: data
            )
            // print(dataInfo)
            return dataInfo
        } catch let error {
            print("Error: \(error)")
            return nil
        }
    }

    // MARK: - Search
    func processDataSearch(data: Data) -> SearchModel? {
        do {
            let dataInfo = try JSONDecoder().decode(SearchModel.self, from: data)
            return dataInfo
        } catch let error {
            print("Error: \(error)")
            return nil
        }
    }

}
