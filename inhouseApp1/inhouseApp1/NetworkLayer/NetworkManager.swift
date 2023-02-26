//
//  networkLayer.swift
//  inhouseApp1
//
//  Created by alejandro on 11/07/22.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
    typealias GetCallback = (Data, MovieError?) -> Void
    func get(endPoint: EndPointType, callback: @escaping GetCallback)
}

class NetworkManager {
    private let manager: Alamofire.Session

    init(manager: Alamofire.Session) {
        self.manager = manager
    }
}

extension NetworkManager: NetworkProtocol {
    func get(endPoint: EndPointType, callback: @escaping GetCallback) {
        manager.request(endPoint.requestUrl, method: endPoint.method ,
                        parameters: endPoint.parameters).responseData { afData in
            switch afData.result {
            case .failure: callback(Data(), MovieError.noData)
            case .success: callback(afData.data ?? Data(), nil)
            }
        }
    }
}
