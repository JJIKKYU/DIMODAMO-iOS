//
//  TabBarViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
//    let coustmeTabBarView: UIView = {
//        
//        //  daclare coustmeTabBarView as view
//        let view = UIView(frame: .zero)
//        
//        // to make the cornerRadius of coustmeTabBarView
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 16
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        view.clipsToBounds = true
//        
//        // to make the shadow of coustmeTabBarView
//        view.layer.masksToBounds = false
//        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 4.0)
//        view.layer.shadowOpacity = 1
//        view.layer.shadowRadius = 16
//        return view
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        addcoustmeTabBarView()
//        hideTabBarBorder()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        coustmeTabBarView.frame = tabBar.frame
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        //            var newSafeArea = UIEdgeInsets()
//        //
//        //            // Adjust the safe area to the height of the bottom views.
//        //            newSafeArea.bottom += coustmeTabBarView.bounds.size.height
//        //
//        //            // Adjust the safe area insets of the
//        //            //  embedded child view controller.
//        //            self.children.forEach({$0.additionalSafeAreaInsets = newSafeArea})
//    }
//    
//    private func addcoustmeTabBarView() {
//        //
//        coustmeTabBarView.frame = tabBar.frame
//        view.addSubview(coustmeTabBarView)
//        view.bringSubviewToFront(self.tabBar)
//    }
//    
//    
//    func hideTabBarBorder()  {
//        let tabBar = self.tabBar
//        tabBar.backgroundImage = UIImage.from(color: .clear)
//        tabBar.shadowImage = UIImage()
//        tabBar.clipsToBounds = true
//        
//    }
//    
//    func invisible() {
//        coustmeTabBarView.isHidden = true
//        tabBar.isHidden = true
//    }
//    
//    func visible() {
//        coustmeTabBarView.isHidden = false
//        tabBar.isHidden = false
//    }
    
    
}






extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
