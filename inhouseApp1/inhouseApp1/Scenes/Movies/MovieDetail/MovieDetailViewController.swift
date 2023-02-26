//
//  MovieDetailViewController.swift
//  inhouseApp1
//
//  Created by alejandro on 1/09/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    weak var presenter: MoviesPresenterProtocol?
    var dataSource: MovieDetailDataSource?
    private let collectionView = UICollectionView(frame: .zero,
                                            collectionViewLayout: UICollectionViewFlowLayout())
    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.color = .white
        activity.hidesWhenStopped = true
        return activity
    }()
    private let movie: Movie

    init(movie: Movie, presenter: MoviesPresenterProtocol) {
        self.movie = movie
        self.presenter = presenter
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createConstraints()
        estimatedFlowLayout()
        navigationBar()
        presenter?.delegate = self
        presenter?.loadDetails(with: movie)
    }
    private func estimatedFlowLayout() {
        let collectionViewLayout =  UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.estimatedItemSize =  CGSize(width: collectionView.bounds.width, height: 650)
        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = collectionViewLayout
    }

    private func createConstraints() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        collectionView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let constraintCollectionView = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let constraintActivityIndicator = [
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraintCollectionView)
        NSLayoutConstraint.activate(constraintActivityIndicator)
    }

    private func navigationBar() {
        let shareButton = UIBarButtonItem(title: "",
                                        style: .done,
                                        target: self,
                                          action: #selector(share) )
        shareButton.image = UIImage(systemName: "square.and.arrow.up")
        shareButton.tintColor = .white
        self.navigationItem.setRightBarButton(shareButton, animated: true)
    }
    @objc private func share() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? MovieDetailTopCell
        presenter?.shareMovie(movie: movie, viewController: self, image: cell?.poster.image)
    }
    func collectionData(result: Result<MovieDetailModel,Error>) {
        switch result {
        case .success(let movieDetail):
            let sectionStruct = SectionModel(movie: movieDetail)
            dataSource = MovieDetailDataSource(collectionView: collectionView, sections: [sectionStruct])
            collectionView.dataSource = dataSource
        case .failure(let error):
            print("fallo fecthMovie \(error)")
        }
        activityIndicator.stopAnimating()
    }

}
extension MovieDetailViewController: MoviesPresenterDelegate {
    func loadedMovies(_ movies: [Movie], section: MoviesSection) {
    }
    func presenterMovieDetails(with result: Result<MovieDetailModel, Error>) {
        collectionData(result: result)
    }
}
