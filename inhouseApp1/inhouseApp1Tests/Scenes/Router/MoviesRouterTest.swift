//
//  RouterTest.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 23/11/22.
//

import XCTest
import UIKit
@testable import inhouseApp1

final class MoviesRouterTest: XCTestCase {

    var navigation: UInavigationControllerMock!
    var router: MoviesRouter!
    var presenter: PresenterMock!
    override func setUp() {
        super.setUp()
        navigation = UInavigationControllerMock()
        router = MoviesRouter(navigation: navigation)
        presenter = PresenterMock()
    }
    
    func testShareDetailsSuccess() {
        // Given
        let viewController = RouterViewControllerMock()
        guard let bundle = Bundle(for: self.classForCoder).resourceURL?.appendingPathComponent("strangerThings.jpg") else {
            return
        }
        guard let image = UIImage(contentsOfFile: bundle.path) else {
            return
        }
        router.shareDetails(name: "hello", image: image, viewController: viewController)
        // Expect
        XCTAssertTrue(viewController.presentWasCalled)
    }
    
    func testShowDetailsSuccess() {
        // Given
        let movie = Movie(id: 1111, title: nil, posterPath: nil, mediaType: nil, popularity: nil, lenguage: nil, releaseDate: nil, voteAverage: nil, name: nil, originalName: nil, firstAirDate: nil)
        // Then
        router.showDetails(for: movie, with: presenter)
        // Expect
        XCTAssertTrue(navigation.pushViewControllerWasCalled)
        XCTAssertTrue(navigation.viewControllers.contains(where: {$0 is MovieDetailViewController}))
    }
    
    func testInitialControllerSuccess() {
        // Given
        let _ = router.initialController(with: presenter)
        // Expect
        XCTAssertTrue(navigation.setViewControllersWasCalled)
        XCTAssertTrue(navigation.viewControllers.contains(where: {$0 is HomeViewController}))
    }
    

    
}
