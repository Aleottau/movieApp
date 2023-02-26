//
//  UInavigationControllerMock.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 23/11/22.
//

import UIKit

class UInavigationControllerMock: UINavigationController {
    
    var pushViewControllerWasCalled = false
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    pushViewControllerWasCalled = true
        super.pushViewController(viewController, animated: false)
    }
    
    var setViewControllersWasCalled = false
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        setViewControllersWasCalled = true
        super.setViewControllers(viewControllers, animated: false)
    }
}
