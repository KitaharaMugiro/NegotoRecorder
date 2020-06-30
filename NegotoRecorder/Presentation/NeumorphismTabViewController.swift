//
//  NeumorphismTabViewController.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/18.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import UIKit
import NeumorphismTab

class NeumorphismViewController: NeumorphismTabBarController {

    override func setupView() {
        let home = NeumorphismTabBarItem(icon: UIImage(systemName: "house.fill")!, title: "record".localized)
        let favorite = NeumorphismTabBarItem(icon: UIImage(systemName: "list.bullet")!, title: "history".localized)
        let color = MyColors.theme
        view.backgroundColor = color
        
        let homeViewController: RecordViewController = {
            let viewController = RecordViewController()
            viewController.view.backgroundColor = color
            return viewController
        }()

        let favoriteViewController: UIViewController = {
            let viewController = NegotListViewController()
            viewController.view.backgroundColor = color
            return viewController
        }()

        setTabBar(items: [home, favorite])
        viewControllers = [homeViewController, favoriteViewController]
    }
    
}
