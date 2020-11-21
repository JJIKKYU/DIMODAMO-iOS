//
//  Hide_ShowNavigationController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        view.layer.layoutIfNeeded()
        setNavigationBarHidden(false, animated: true)
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.textSmall)]
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        
        view.layer.layoutIfNeeded()
        
    }
    
    public func hideTransparentNavigationBar() {
        view.layer.layoutIfNeeded()
        setNavigationBarHidden(false, animated: true)
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
        
        
        view.layer.layoutIfNeeded()
        
        
    }
}
