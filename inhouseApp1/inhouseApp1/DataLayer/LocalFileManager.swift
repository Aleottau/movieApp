//
//  FileManager.swift
//  inhouseApp1
//
//  Created by alejandro on 27/10/22.
//

import Foundation
import UIKit
protocol LocalFileManagerProtocol {
    func saveImageFromHome(image: UIImage, imageNameId: String?)
    func saveImageFromDetails(image: UIImage, imageNameId: String?)
    func getHomeImage(imageNameId: String) -> UIImage?
    func getDetailsImage(imageNameId: String) -> UIImage?
}

class LocalFileManager {
    let fileManager: FileManager
    let directoryPath: URL?
    let list = "_list.jpeg"
    let details = "_details.jpeg"
    init(fileManager: FileManager = .default, directoryName: String = "MovieImages" ) {
        self.fileManager = fileManager
        let directoryDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        self.directoryPath = directoryDocument?.appendingPathComponent(directoryName)
    }

    func createFolder() {
        guard let directoryPath = directoryPath else {
            return
        }
        print(directoryPath)
        guard !fileManager.fileExists(atPath: directoryPath.path) else {
            return
        }
        do {
            try fileManager.createDirectory(
                at: directoryPath,
                withIntermediateDirectories: true,
                attributes: nil)
            print("se creo folder : \(directoryPath)")
        } catch {
            print("Error creating directory. \(error)")
        }
    }
    private func validateData(image: UIImage, imageNameId: String?) {
        guard let data = image.jpegData(compressionQuality: 0), let imageName = imageNameId else {
            return
        }
        guard let imageURL = directoryPath?.appendingPathComponent(imageName) else {
            return
        }
        do {
            try data.write(to: imageURL)
        } catch {
            print("error de guardado de imagen: \(imageName). \n \(error)")
        }
    }
    private func validateImageURL(imageNameId: String) -> UIImage? {
        guard let imageURL = directoryPath?.appendingPathComponent(imageNameId) else {
            return nil
        }
        guard let data = try? Data(contentsOf: imageURL) else {
            return nil
        }
        return UIImage(data: data)
    }
}

extension LocalFileManager: LocalFileManagerProtocol {
    func getDetailsImage(imageNameId: String) -> UIImage? {
        return validateImageURL(imageNameId: imageNameId + details)
    }

    func getHomeImage(imageNameId: String) -> UIImage? {
        return validateImageURL(imageNameId: imageNameId + list)
    }

    func saveImageFromHome(image: UIImage, imageNameId: String?) {
        validateData(image: image, imageNameId: (imageNameId ?? "") + list)
    }

    func saveImageFromDetails(image: UIImage, imageNameId: String?) {
        validateData(image: image, imageNameId: (imageNameId ?? "") + details)
    }
}
