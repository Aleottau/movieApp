//
//  HomeDataSource.swift
//  inhouseApp1
//
//  Created by alejandro on 10/08/22.
//

import Foundation
import UIKit
import Alamofire

class HomeDataSource: NSObject {

    private var trendingMovies: [Movie] = []
    private var topRated: [Movie] = []
    private var popular: [Movie] = []
    private var search: [Movie] = []
    let headerId = "headerId"
    let config = URLSessionConfiguration.default
    lazy var networkManager: NetworkProtocol = NetworkManager(
        manager: Alamofire.Session(configuration: config)
    )
    lazy var movieRepository: MovieRepositoryProtocol = MoviesRepository(
        networkManager: networkManager,
        endPoints: MovieListEndPoint.self,
        fileManager: LocalFileManager(),
        dataManager: DataManager()
    )

    init(collection: UICollectionView) {
        super.init()
        registerCell(collection: collection)
        registerHeader(collection: collection)
    }
    func save(movies: [Movie], for section: MoviesSection) {
        switch section {
        case .trending:
            trendingMovies = movies
        case .topRated:
            topRated = movies
        case .popular:
            popular = movies
        case .search:
            search = movies
        }
    }
    private func registerCell(collection: UICollectionView) {
        let nib = UINib(nibName: NewHomeCell.identifier, bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: NewHomeCell.identifier )
    }

    private func registerHeader(collection: UICollectionView) {
        collection.register(
            SectionHeaders.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId
        )
    }
    func modelFrom(indexpath: IndexPath) -> Movie? {
        switch indexpath.section {
        case 0: return trendingMovies[indexpath.row]
        case 1: return topRated[indexpath.row]
        case 2: return popular[indexpath.row]
        case 3: return search[indexpath.row]
        default:
            return nil
        }
    }
    func getSectionTitle(indexpath: IndexPath) -> String? {
        switch indexpath.section {
        case 0: return "Trending Top"
        case 1: return "Top Rated"
        case 2: return "Popular"
        case 3: return "Search Results"
        default:
            return nil
        }
    }
    func cellConfiguration(cell: UICollectionViewCell) {
        cell.contentView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
    }
}
extension HomeDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return trendingMovies.count
        case 1: return topRated.count
        case 2: return popular.count
        case 3: return search.count
        default:
            return 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewHomeCell.identifier,
            for: indexPath
        ) as? NewHomeCell else {
            return UICollectionViewCell()
        }
        guard let item = modelFrom(indexpath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setModel(model: item, indexPath: (indexPath.row + 1))
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        movieRepository.fetchMoviePoster(movie: item) { result in
            cell.posterImageView.image =  try? result.get()
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.hidesWhenStopped = true
        }
        cellConfiguration(cell: cell)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: headerId,
                    for: indexPath
                ) as? SectionHeaders else {
                    return UICollectionReusableView()
                }
                header.sectionTitle.text = getSectionTitle(indexpath: indexPath)
                return header
            } else {
                return UICollectionReusableView()
            }
        }
}
