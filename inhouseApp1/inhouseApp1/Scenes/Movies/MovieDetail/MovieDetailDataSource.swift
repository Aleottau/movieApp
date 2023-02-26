//
//  TopMovieDetailDataSource.swift
//  inhouseApp1
//
//  Created by alejandro on 2/09/22.
//

import UIKit
import Alamofire
protocol MovieDetailItem {}
protocol MovieDetailCell where Self: UICollectionViewCell {
    static var identifier: String { get }
    func setUpWith(model: MovieDetailItem)
    func fetchMovie(movie: MovieDetailItem, cell: MovieDetailCell, movieRepository: MovieRepositoryProtocol)
}

class MovieDetailDataSource: NSObject {
    var sections: [SectionModel]
    let config = URLSessionConfiguration.default
    lazy var networkManager: NetworkProtocol = NetworkManager(manager: Alamofire.Session(configuration: config))
    lazy var movieRepository: MovieRepositoryProtocol = MoviesRepository(networkManager: networkManager,
                                                                endPoints: MovieListEndPoint.self,
                                                                fileManager: LocalFileManager(),
                                                                dataManager: DataManager()
                                                                )
    init(collectionView: UICollectionView, sections: [SectionModel]) {
        self.sections = sections
        super.init()
        registerCell(collection: collectionView, identifier: MovieDetailTopCell.identifier)
        registerCell(collection: collectionView, identifier: MovieDetailMidCell.identifier)
        registerCell(collection: collectionView, identifier: MovieDetailBotCell.identifier)
    }

    private func registerCell(collection: UICollectionView, identifier: String) {
        let nibTop = UINib(nibName: identifier, bundle: nil)
        collection.register(nibTop, forCellWithReuseIdentifier: identifier)
    }
}
extension MovieDetailDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    // swiftlint:disable line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        var cellType: MovieDetailCell.Type?
        switch item {
        case _ as TopMovieDetail:
            cellType = MovieDetailTopCell.self
        case _ as MidMovieDetail:
            cellType = MovieDetailMidCell.self
        case _ as BotMovieDetail:
            cellType = MovieDetailBotCell.self
        default:
            return UICollectionViewCell()
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType?.identifier ?? "",
            for: indexPath
        ) as? MovieDetailCell else {
            return UICollectionViewCell()
        }
        cell.setUpWith(model: item)
        cell.fetchMovie(movie: item, cell: cell, movieRepository: movieRepository)
        return cell
    }
}
