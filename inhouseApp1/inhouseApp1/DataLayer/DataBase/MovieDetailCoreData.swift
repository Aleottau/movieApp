//
//  MovieDetailCoreData.swift
//  inhouseApp1
//
//  Created by alejandro on 12/10/22.
//

import Foundation
import CoreData

class MovieDetailCoreData: NSManagedObject {
    @NSManaged var movieCDid: Int32
    @NSManaged var budget: Int32
    @NSManaged var revenue: Int64
    @NSManaged var runtime: Int32
    @NSManaged var voteCount: Int32
    @NSManaged var voteAverage: NSDecimalNumber
    @NSManaged var releaseDate: String
    @NSManaged var originalTitle: String
    @NSManaged var overview: String
    @NSManaged var status: String
    @NSManaged var homepage: String
    @NSManaged var genres: Set<GenresCoreData>
    let genresKey = "genres"

     convenience init?(managedObjectContext: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "MovieDetailCoreData",
                                                       in: managedObjectContext)
        guard let entityDescription = entityDescription else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)
    }

    func addData(with movie: MovieDetailModel, managedObjectContext: NSManagedObjectContext) {
        self.movieCDid = Int32(movie.id)
        self.budget = Int32(movie.budget ?? 0)
        self.revenue = Int64(movie.revenue)
        self.runtime = Int32(movie.runtime ?? 0)
        self.voteCount = Int32(movie.voteCount)
        self.voteAverage = NSDecimalNumber(value: movie.voteAverage)
        self.releaseDate = movie.releaseDate
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview ?? ""
        self.status = movie.status
        self.homepage = movie.homepage ?? ""
    }
    // swiftlint: disable force_cast
    func addToGenres(_ value: GenresCoreData) {
        let genresRelation = mutableSetValue(forKey: genresKey)
        genresRelation.add(value)
        genres = genresRelation as! Set<GenresCoreData>
    }

    func removeFromGenres(_ value: GenresCoreData) {
        let genresRelation = mutableSetValue(forKey: genresKey)
        genresRelation.remove(value)
        genres = genresRelation as! Set<GenresCoreData>
    }

    func addToGenres(_ values: Set<GenresCoreData>) {
        let genresRelation = mutableSetValue(forKey: genresKey)
        let genresCd: [Any] = values.map { $0 }
        genresRelation.addObjects(from: genresCd)
        genres = genresRelation as! Set<GenresCoreData>
    }

    func removeFromGenres(_ values: Set<GenresCoreData>) {
        let genresRelation = mutableSetValue(forKey: genresKey)
        _ = values.map { genresRelation.remove($0) }
        genres = genresRelation as! Set<GenresCoreData>
    }

}
