//
//  MoviesRouter.swift
//  inhouseApp1
//
//  Created by alejandro on 20/09/22.
//

import Foundation
import UIKit

protocol MoviesRouterProtocol {
    func initialController(with prensenter: MoviesPresenterProtocol) -> UIViewController
    func showDetails(for movie: Movie, with presenter: MoviesPresenterProtocol)
    func shareDetails(name: String, image: UIImage, viewController: UIViewController)
}

class MoviesRouter {
    var navigation: UINavigationController
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
}

extension MoviesRouter: MoviesRouterProtocol {
    func shareDetails(name: String, image: UIImage, viewController: UIViewController) {
        let share = UIActivityViewController(activityItems: [name, image],
                                             applicationActivities: nil)
        share.popoverPresentationController?.sourceView = viewController.view
        viewController.present(share, animated: true)
    }

    func showDetails(for movie: Movie, with presenter: MoviesPresenterProtocol) {
        let controller = MovieDetailViewController(movie: movie, presenter: presenter)
        navigation.pushViewController(controller, animated: true)
    }

    func initialController(with prensenter: MoviesPresenterProtocol) -> UIViewController {
        let homeViewController = HomeViewController(presenter: prensenter)
        navigation.setViewControllers([homeViewController], animated: false)
        return navigation
    }
}
