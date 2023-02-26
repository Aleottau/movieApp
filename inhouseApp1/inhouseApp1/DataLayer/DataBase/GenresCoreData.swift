//
//  GenresCoreData.swift
//  inhouseApp1
//
//  Created by alejandro on 12/10/22.
//

import Foundation
import CoreData

class GenresCoreData: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var detail: Set<MovieDetailCoreData>
    let movieKey = "detail"

     convenience init?(managedObjectContext: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "GenresCoreData",
                                                       in: managedObjectContext)
        guard let entityDescription = entityDescription else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)
    }

    func addData(genre: GenreMovie) {
        self.name = genre.name
    }
    // swiftlint: disable force_cast
    func addToDetail(_ value: MovieDetailCoreData) {
        let movieRelation = mutableSetValue(forKey: movieKey)
        movieRelation.add(value)
        detail = movieRelation as! Set<MovieDetailCoreData>
    }

    func removeFromDetail(_ value: MovieDetailCoreData) {
        let movieRelation = mutableSetValue(forKey: movieKey)
        movieRelation.remove(value)
        detail = movieRelation as! Set<MovieDetailCoreData>
    }

    func addToDetail(_ values: Set<MovieDetailCoreData>) {
        let movieRelation = mutableSetValue(forKey: movieKey)
        let movieCd: [Any] = values.map { $0 }
        movieRelation.addObjects(from: movieCd)
        detail = movieRelation as! Set<MovieDetailCoreData>
    }

    func removeFromDetail(_ values: Set<MovieDetailCoreData>) {
        let movieRelation = mutableSetValue(forKey: movieKey)
        _ = values.map { movieRelation.remove($0) }
        detail = movieRelation as! Set<MovieDetailCoreData>
    }
}
