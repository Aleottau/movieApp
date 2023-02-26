//
//  FileManagerMock.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 25/11/22.
//

import Foundation
import UIKit
@testable import inhouseApp1

class FileManagerMock: LocalFileManagerProtocol {
    var saveImageFromHomeWasCalled = false
    func saveImageFromHome(image: UIImage, imageNameId: String?) {
        saveImageFromHomeWasCalled = true
    }
    var saveImageFromDetailsWasCalled = false
    func saveImageFromDetails(image: UIImage, imageNameId: String?) {
        saveImageFromDetailsWasCalled = true
    }
    var getHomeImageWasCalled = false
    var getHomeImageBool = false
    func getHomeImage(imageNameId: String) -> UIImage? {
        getHomeImageWasCalled = true
        return getHomeImageBool ? UIImage() : nil
    }
    var getDetailsImageWasCalled = false
    var getDetailImageBool = false
    func getDetailsImage(imageNameId: String) -> UIImage? {
        getDetailsImageWasCalled = true
        return getDetailImageBool ? UIImage() : nil
    }
    
    
}
