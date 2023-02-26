//
//  NetworkManagerMock.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 25/11/22.
//

import Foundation
@testable import inhouseApp1

class NetworkManagerMock: NetworkProtocol {
    var getWascalled = false
    var expectedError: MovieError?
    func get(endPoint: inhouseApp1.EndPointType, callback: @escaping GetCallback) {
        getWascalled = true
        if let error = expectedError {
            callback(Data(), error)
        } else {
            callback(Data(), nil)
        }
    }
    
    
}
