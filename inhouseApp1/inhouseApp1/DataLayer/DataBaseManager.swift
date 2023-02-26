//
//  DataBaseManager.swift
//  inhouseApp1
//
//  Created by alejandro on 4/10/22.
//

import Foundation
import CoreData
protocol DataBaseManagerProtocol {
    static var persistentContainer: NSPersistentContainer { get }
    func getContext() -> NSManagedObjectContext
    func saveContext()
    // home
    func saveMovieObject(movies: [Movie])
    func getAllMovies(completion: @escaping ([Movie]) -> Void)
    func searchMovieByName(query: String, completion: @escaping ([Movie]) -> Void)
    // details
    func saveDetailObject(movieDetail: MovieDetailModel)
    func getMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailModel,Error>) -> Void)
}
class DataBaseManager {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ModelDb")
        container.loadPersistentStores(completionHandler: { (description, error) in
            print(description.url ?? "")
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
}

extension DataBaseManager: DataBaseManagerProtocol {
    // MARK: - DETAIL
    func saveDetailObject(movieDetail: MovieDetailModel) {
        guard let movieDetailCD = MovieDetailCoreData(managedObjectContext: self.getContext()) else {
            return
        }
        movieDetailCD.addData(with: movieDetail, managedObjectContext: self.getContext())
        let genresCD: [GenresCoreData] = movieDetail.genres.compactMap { genreMovie in
            let genreCd = self.filterGenresFromNet(genreMovie: genreMovie)
            return genreCd
        }
        let genreSet = Set(genresCD)
        movieDetailCD.addToGenres(genreSet)
        genreSet.forEach { $0.addToDetail(movieDetailCD)}
        self.saveContext()
        getContext().reset()
    }

    func filterGenresFromNet(genreMovie: GenreMovie) -> GenresCoreData? {
        let  fetchGenres = NSFetchRequest<NSFetchRequestResult>(entityName: "GenresCoreData")
        fetchGenres.predicate = NSPredicate(format: "name == %@", genreMovie.name)
        if let genresFetch = try? self.getContext().fetch(fetchGenres).first as? GenresCoreData {
            return genresFetch
        } else {
            let genresCD = GenresCoreData(managedObjectContext: self.getContext())
            genresCD?.addData(genre: genreMovie)
            return genresCD
        }
    }

    func getMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailModel,Error>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetailCoreData")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "movieCDid == %i", movieId)
        fetchRequest.relationshipKeyPathsForPrefetching = ["genres"]
        do {
            guard let movieFetch = try self.getContext().fetch(fetchRequest).first
                    as? MovieDetailCoreData else {
                return
            }
            let movieDetailStruct = MovieDetailModel(need: movieFetch)
            completion(.success(movieDetailStruct))
        } catch {
            print("fallo get movie\(error)")
            completion(.failure(error))
        }
    }

    // MARK: - HOME
    func searchMovieByName(query: String, completion: @escaping ([Movie]) -> Void) {
        let  fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieCoreData")
        fetchRequest.predicate = NSPredicate(format: "title BEGINSWITH %@", query)
        do {
            guard let movieResult = try self.getContext().fetch(fetchRequest) as? [MovieCoreData] else {
                return
            }
            let movieStruct = movieResult.map { Movie(need: $0) }
            completion(movieStruct)
        } catch {
            completion([])
            print("error movie search is empty \(error)")
        }
    }

    func getAllMovies(completion: @escaping ([Movie]) -> Void) {
        let  fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieCoreData")
        fetchRequest.fetchLimit = 20
        do {
            guard let moviesResult = try self.getContext().fetch(fetchRequest) as? [MovieCoreData] else {
                completion([])
                return
            }
            let movieStruct = moviesResult.map {  Movie(need: $0) }
            completion(movieStruct)
        } catch {
            completion([])
            print("error movie vacia: \(error)")
        }
    }

    func saveMovieObject(movies: [Movie]) {
        var moviesSaved: [MovieCoreData?] = []
        for item in movies {
            let movie = MovieCoreData(managedObjectContext: self.getContext())
            movie?.addData(with: item)
            moviesSaved.append(movie)
        }
        self.saveContext()
        getContext().reset()
    }

    // MARK: - CONTEXT FUNCTION
    func getContext() -> NSManagedObjectContext {
        return DataBaseManager.persistentContainer.viewContext
    }

    func saveContext() {
        let context = DataBaseManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror)")
            }
        }
    }
}
