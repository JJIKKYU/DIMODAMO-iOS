//
//  RoundedTabBar.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import UIKit

// MARK: - GNB 라운드

extension UITabBarController {
    func roundedTabbar() {
        self.tabBar.layer.masksToBounds = false
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .black
        self.tabBar.layer.cornerRadius = 24
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.appShadow(.s20)
    }
}


// MARK: - 하단 밑줄 제거

extension UINavigationController {
    func hideBottomTabbarLine() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
