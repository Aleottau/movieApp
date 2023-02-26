//
//  PresenterMock.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 24/11/22.
//

import Foundation
@testable import inhouseApp1
import UIKit

class PresenterMock: MoviesPresenterProtocol {
    var delegate: inhouseApp1.MoviesPresenterDelegate?
    
    func setUpInitial(windowScene: UIWindowScene) -> UIWindow {
        return UIWindow()
    }
    
    func viewDidLoad(completion: @escaping (Result<[inhouseApp1.Movie], inhouseApp1.MovieError>) -> Void) {
    }
    
    func viewDidLoad() {
    }
    
    func showDetails(for movie: inhouseApp1.Movie) {
    }
    
    func loadDetails(with movie: inhouseApp1.Movie) {
    }
    
    func shareMovie(movie: inhouseApp1.Movie, viewController: UIViewController, image: UIImage?) {
    }
    
    func searchMovie(query: String) {
    }
    
    func registerNotification() {
    }
    
    
}
