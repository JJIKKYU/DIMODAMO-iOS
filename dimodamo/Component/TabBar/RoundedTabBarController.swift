//
//  RoundedTabBarController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/22.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class RoundedTabBarController: UITabBarController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        guard let bottomSafeArea = window?.safeAreaInsets.bottom else {
            return
        }
        
        
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: self.tabBar.bounds.minY, width: self.tabBar.bounds.width, height: self.tabBar.bounds.height + bottomSafeArea), cornerRadius: 24).cgPath
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        
        self.view.backgroundColor = UIColor.appColor(.system)
        tabBar.backgroundColor = UIColor.black
        
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.appColor(.white255).cgColor
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
        if let items = self.tabBar.items {
          items.forEach { item in item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0) }
        }
    }
}
