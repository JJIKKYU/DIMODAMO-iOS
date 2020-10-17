//
//  ArticleDetailViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    
    @IBOutlet weak var articleCategory: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
//
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let insets = UIEdgeInsets(top: -self.topLayoutGuide.length, left: 0, bottom: 0, right: 0)
//        scrollView.contentInset = insets
//        scrollView.scrollIndicatorInsets = insets
//    }
}


extension ArticleDetailViewController {
    func viewDesign() {
//        articleCategory.articleCategoryDesign()
    }
}
