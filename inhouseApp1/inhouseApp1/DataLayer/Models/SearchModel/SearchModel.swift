//
//  SearchModel.swift
//  inhouseApp1
//
//  Created by alejandro on 23/09/22.
//

import Foundation

struct SearchModel: Codable {
    let results: [Movie]
    enum CodingKeys: String, CodingKey {
        case results
    }
}
