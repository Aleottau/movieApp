//
//  HomeDiffableDataSource.swift
//  inhouseApp1
//
//  Created by alejandro on 3/01/23.
//

import Foundation
import UIKit
import Alamofire

// swiftlint: disable line_length
protocol HomeDiffableDataSourceProtocol {
    var dataSource: HomeDiffableDataSource.DiffDataSource { get }
    func save(movies: [Movie], for section: MoviesSection)
    func applySnapshot(animatingDiff: Bool, isSearching: Bool)
    func modelFrom(indexpath: IndexPath, itemIdentifier: Int) -> Movie?
}
class HomeDiffableDataSource {

    private var trendingMovies: [Movie] = []
    private var topRated: [Movie] = []
    private var popular: [Movie] = []
    private var search: [Movie] = []
    var isSearchingState: Bool = false
    let headerId = "headerId"
    private var collectionView: UICollectionView
    typealias DiffDataSource = UICollectionViewDiffableDataSource<MoviesSection, Int>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MoviesSection, Int>
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
    lazy var dataSource: HomeDiffableDataSource.DiffDataSource = makeDataSource()

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        registerCell(collection: collectionView)
        registerHeader(collection: collectionView)
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
    func modelFrom(indexpath: IndexPath, itemIdentifier: Int) -> Movie? {
        guard !isSearchingState else {
            return search.first { $0.id == itemIdentifier}
        }
        switch indexpath.section {
        case 0: return trendingMovies.first { $0.id == itemIdentifier}
        case 1: return topRated.first { $0.id == itemIdentifier}
        case 2: return popular.first { $0.id == itemIdentifier}
        default:
            return nil
        }
    }
    private func cellConfiguration(cell: UICollectionViewCell) {
        cell.contentView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
    }

    private func makeDataSource() -> DiffDataSource {
        let dataSource = DiffDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewHomeCell.identifier,
                for: indexPath
            ) as? NewHomeCell else {
                return UICollectionViewCell()
            }
            guard let movie = self?.modelFrom(indexpath: indexPath, itemIdentifier: itemIdentifier) else {
                return UICollectionViewCell()
            }
            cell.setModel(model: movie, indexPath: (indexPath.row + 1))
            cell.activityIndicator.startAnimating()
            cell.activityIndicator.isHidden = false
            self?.movieRepository.fetchMoviePoster(movie: movie) { result in
                cell.posterImageView.image =  try? result.get()
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.hidesWhenStopped = true
            }
            self?.cellConfiguration(cell: cell)
            return cell
        }
        makeHeader(dataSource: dataSource)
        return dataSource
    }
    private func makeHeader(dataSource: DiffDataSource) {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: self!.headerId,
                    for: indexPath
                ) as? SectionHeaders else {
                    return UICollectionReusableView()
                }
                header.sectionTitle.text = self?.getSectionTitle(indexpath: indexPath)
                return header
            } else {
                return UICollectionReusableView()
            }
        }
    }
    private func getSectionTitle(indexpath: IndexPath) -> String? {
        guard !isSearchingState else {
            return "Search Results"
        }
        switch indexpath.section {
        case 0: return "Trending Top"
        case 1: return "Top Rated"
        case 2: return "Popular"
        default:
            return nil
        }
    }
}

extension HomeDiffableDataSource: HomeDiffableDataSourceProtocol {
    func applySnapshot(animatingDiff: Bool = true, isSearching: Bool) {
        var snapshot = Snapshot()
        isSearchingState = isSearching
        if isSearching {
            snapshot.appendSections([.search])
            snapshot.appendItems(search.map({ $0.id }), toSection: .search)
            dataSource.apply(snapshot, animatingDifferences: animatingDiff)
        } else {
            snapshot.appendSections([.trending, .topRated, .popular])
            snapshot.appendItems(trendingMovies.map({ $0.id }), toSection: .trending)
            snapshot.appendItems(topRated.map({ $0.id }), toSection: .topRated)
            snapshot.appendItems(popular.map({ $0.id }), toSection: .popular)
            dataSource.apply(snapshot, animatingDifferences: animatingDiff)
        }
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
}
