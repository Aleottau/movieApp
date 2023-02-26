//
//  EndPointType.swift
//  inhouseApp1
//
//  Created by alejandro on 13/07/22.
//

import Foundation
import Alamofire

protocol EndPointType {
    var baseUrl: URL { get }
    var baseUrlImage: URL { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var requestUrl: URL { get }
    var parameters: [String: Any]? { get }
}

extension EndPointType {
    var baseUrl: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    var baseUrlImage: URL {
        return URL(string: "https://image.tmdb.org/t/p/original")!
    }
    func dictionaryBase() -> [String: Any] {
        return ["api_key":"5bae4b813f03cae515380880bcd7600f"]
    }
    func dictionaryBaseSearch(need query: String) -> [String: Any] {
        var dictionary = dictionaryBase()
        dictionary["query"] = query
        return dictionary
    }
}
