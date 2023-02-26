//
//  MovieError.swift
//  inhouseApp1
//
//  Created by alejandro on 17/07/22.
//

import Foundation

enum MovieError: Error {
    case apiError
    case invalidEndPoint
    case invalidResponse
    case noData
    case serializationError
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fecth data"
        case .invalidEndPoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode"
        }
    }
}
