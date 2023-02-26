//
//  movieListEndPoint.swift
//  inhouseApp1
//
//  Created by alejandro on 17/07/22.
//

import Foundation
import Alamofire
import CoreVideo

enum MediaType: String {
    case all
    case movie
    case person
    // swiftlint:disable identifier_name
    case tv
}

enum TimeWindow: String {
    case day
    case week
}

enum MovieListEndPoint {
    case trending(mediaType: MediaType, timeWindow: TimeWindow)
    case movie(id: Int)
    case search(query: String)
    case images(image: String)
    case popular
    case topRated
    var description: String {
        switch self {
        case .trending(mediaType: _, timeWindow: _): return "Trending"
        case .movie(id: _):  return "Movies"
        case .search: return "Search Movie"
        case .images(image: _): return "Movie image"
        case .popular: return "Movie Popular"
        case .topRated: return "Movie Top Rated"
        }
    }
}

extension MovieListEndPoint: EndPointType {
    var parameters: [String: Any]? {
        switch self {
        case .trending(mediaType: _, timeWindow: _):
            return dictionaryBase()
        case .movie(id: _):
            return dictionaryBase()
        case .images(image: _):
            return nil
        case .search(query: let query):
            return dictionaryBaseSearch(need: query)
        case .popular:
            return dictionaryBase()
        case .topRated:
            return dictionaryBase()
        }
    }
    var requestUrl: URL {
        switch self {
        case .images:
            return baseUrlImage.appendingPathComponent(path)
        default:
            return baseUrl.appendingPathComponent(path)
        }
    }
    var path: String {
        switch self {
        case .trending(let mediaType, let timeWindow):
            return "/trending/\(mediaType)/\(timeWindow)"
        case .movie(let id):
            return "/movie/\(id)"
        case .search(query: _):
            return "/search/movie"
        case .images(image: let image):
            return "/\(image)"
        case .popular:
            return "/movie/popular"
        case .topRated:
            return "/movie/top_rated"
        }
    }
    var method: Alamofire.HTTPMethod {
        switch self {
        case .trending(mediaType: _, timeWindow: _):
            return .get
        case .movie(id: _):
            return .get
        case .search(query: _):
            return .get
        case .images(image: _):
            return .get
        case .popular:
            return .get
        case .topRated:
            return .get
        }
    }
}
