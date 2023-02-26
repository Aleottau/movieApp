//
//  HomeViewController.swift
//  inhouseApp1
//
//  Created by alejandro on 9/08/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    private var presenter: MoviesPresenterProtocol
    let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HomeCompotitionalLayout().generateLayout()
    )
    var setUpDataSource: HomeDiffableDataSource?
    let searchBarController = UISearchController()
    var isSearchActive = false

    init(presenter: MoviesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
        setUpDataSource = HomeDiffableDataSource(collectionView: collectionView)
        collectionView.dataSource = setUpDataSource?.dataSource
        collectionView.delegate = self
        navigationBar()
        searchBar()
        presenter.viewDidLoadMultiple()
        presenter.registerNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.delegate = self
    }
    func searchBar() {
        navigationItem.searchController = searchBarController
        searchBarController.searchResultsUpdater = self
        searchBarController.searchBar.delegate = self
    }

    private func constraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraintCollectionView = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraintCollectionView)
    }
    private func navigationBar() {
        navigationItem.title = "Trending Top on IMDb this week"
        let settings = UIBarButtonItem(title: "", style: .done, target: self, action: nil )
        settings.image = UIImage(systemName: "ellipsis")
        settings.tintColor = .darkGray
        self.navigationItem.setRightBarButton(settings, animated: true)
        self.navigationItem.backButtonTitle = ""
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let itemIdentifier = setUpDataSource?.dataSource.itemIdentifier(for: indexPath),
            let movie = setUpDataSource?.modelFrom(indexpath: indexPath, itemIdentifier: itemIdentifier)
        else {
            return
        }
        presenter.showDetails(for: movie)
    }
}

extension HomeViewController: MoviesPresenterDelegate {
    func loadedMovies(_ movies: [Movie], section: MoviesSection) {
        setUpDataSource?.save(movies: movies, for: section)
        setUpDataSource?.applySnapshot(isSearching: isSearchActive)
    }
    func presenterMovieDetails(with result: Result<MovieDetailModel, Error>) {
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 1 else {
            return
        }
        isSearchActive = true
        presenter.searchMovie(query: text)
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        setUpDataSource?.applySnapshot(isSearching: isSearchActive)
    }
}
