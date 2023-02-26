//
//  MoviesPresenter.swift
//  inhouseApp1
//
//  Created by alejandro on 20/09/22.
//
import UIKit
import Foundation

enum MoviesSection: Int, CaseIterable {
    case trending
    case topRated
    case popular
    case search
}

protocol MoviesPresenterDelegate: AnyObject {

    func presenterMovieDetails(with result: Result<MovieDetailModel,Error>)
    func loadedMovies(_ movies: [Movie], section: MoviesSection)
}
protocol MoviesPresenterProtocol: AnyObject {
    // var moviesLoaded: ((Result<[Movie], Error>) -> Void)? { get set }
    var delegate: MoviesPresenterDelegate? { get set }
    func setUpInitial(windowScene: UIWindowScene) -> UIWindow
    func viewDidLoadMultiple()
    func showDetails(for movie: Movie)
    func loadDetails(with movie: Movie)
    func shareMovie(movie: Movie, viewController: UIViewController, image: UIImage?)
    func searchMovie(query: String)
    func registerNotification()
}

class MoviesPresenter {
    weak var delegate: MoviesPresenterDelegate?
    var interactor: MoviesInteractorProtocol
    let router: MoviesRouterProtocol

    var moviesLoaded: ((Result<[Movie], Error>) -> Void)?

    init(interactor: MoviesInteractorProtocol, router: MoviesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MoviesPresenter: MoviesPresenterProtocol {
    func registerNotification() {
        interactor.registerNotification()
    }

    // MARK: - Search
    func searchMovie(query: String) {
        interactor.loadSearch(with: query) { [weak self] result in
            self?.checkMovies(result: result, section: .search)
        }
    }

    // MARK: - movieDetails
    func loadDetails(with movie: Movie) {
        interactor.loadMovieDetails(with: movie) { [weak self] result in
            self?.delegate?.presenterMovieDetails(with: result)
        }
    }

    func showDetails(for movie: Movie) {
        router.showDetails(for: movie, with: self)
    }

    func shareMovie(movie: Movie, viewController: UIViewController, image: UIImage?) {
        guard let image = image else {
            interactor.loadPosterDetails(with: movie) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.router.shareDetails(name: movie.name ?? "",
                                           image: image,
                                           viewController: viewController)
                case .failure:
                    break
                }
            }
            return
        }
        router.shareDetails(name: movie.name ?? "", image: image, viewController: viewController)
    }

    // MARK: - home
    func viewDidLoadMultiple() {
        interactor.loadHomeMovies { [weak self] result in
            self?.checkMovies(result: result, section: .trending)
        } topRatedCallback: { [weak self] result in
            self?.checkMovies(result: result, section: .topRated)
        } popularCallback: { [weak self] result in
            self?.checkMovies(result: result, section: .popular)
        }
    }
    func checkMovies( result: Result<[Movie], MovieError>, section: MoviesSection) {
        switch result {
        case .success(let movies):
            self.delegate?.loadedMovies(movies, section: section)
        case .failure(let error):
            print(error)
        }
    }

    func setUpInitial(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = router.initialController(with: self)
        window.makeKeyAndVisible()
        return window
    }
}
