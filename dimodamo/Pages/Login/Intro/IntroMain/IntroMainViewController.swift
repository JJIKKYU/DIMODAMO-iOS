//
//  IntroMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class IntroMainViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedVC" {
            let destinationVC = segue.destination as! IntroPageViewController
            destinationVC.pageDelegate = self
        }
    }
    

}
// MARK: - View Design

extension IntroMainViewController {
    func viewDesign() {
//        pageControl.transform = CGAffineTransform(scaleX: 3, y: 1)
    }
}

// MARK: - 현재 페이지를 받음

extension IntroMainViewController: passCurrentPage {
    func passCurrentPage(page: Int) {
        pageControl.currentPage = page
    }
    
    
}

