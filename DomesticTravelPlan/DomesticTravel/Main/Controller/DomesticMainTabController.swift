//
//  DomesticMainTabController.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/7/29.
//

import UIKit

class DomesticMainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

// MARK: - UITabBarControllerDelegate
extension DomesticMainTabController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
