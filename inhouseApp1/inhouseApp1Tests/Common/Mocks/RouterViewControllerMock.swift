//
//  RouterViewControllerMock.swift
//  inhouseApp1Tests
//
//  Created by alejandro on 23/11/22.
//

import UIKit

class RouterViewControllerMock: UIViewController {

    var presentWasCalled = false
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentWasCalled = true
        super.present(viewControllerToPresent, animated: false, completion: completion)
    }

}
