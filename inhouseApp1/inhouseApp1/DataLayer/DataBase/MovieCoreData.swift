//
//  Movies.swift
//  inhouseApp1
//
//  Created by alejandro on 4/10/22.
//

import Foundation
import CoreData

class MovieCoreData: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var lenguage: String
    @NSManaged var mediaType: String
    @NSManaged var name: String
    @NSManaged var releaseDate: String
    @NSManaged var title: String
    @NSManaged var voteAverage: NSDecimalNumber

     convenience init?(managedObjectContext: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "MovieCoreData",
                                                       in: managedObjectContext)
        guard let entityDescription = entityDescription else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)
    }

    func addData(with movies: Movie) {
        self.id = Int32(movies.id)
        self.lenguage = movies.lenguage ?? ""
        self.mediaType = movies.mediaType ?? ""
        self.name = movies.name ?? ""
        self.releaseDate = movies.releaseDate ?? ""
        self.title = movies.title ?? ""
        self.voteAverage = NSDecimalNumber(value: movies.voteAverage ?? 0.0)
    }
}
