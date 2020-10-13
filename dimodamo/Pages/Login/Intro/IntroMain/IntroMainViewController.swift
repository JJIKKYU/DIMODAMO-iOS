//
//  IntroMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import RxRelay

class IntroMainViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loginBtn: UIButton!
    
    lazy var maxNumberOfPages: Int = pageControl.numberOfPages - 1
    
    var currentPage = BehaviorRelay<Int>(value: 0)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        currentPage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.pageControl.currentPage = value
                if value == self?.maxNumberOfPages {
                    self?.loginBtn.isEnabled = true
                    self?.loginBtn.alpha = 1
                } else {
                    self?.loginBtn.isEnabled = false
                    self?.loginBtn.alpha = 0
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func pressedLoginBtn(_ sender: Any) {
        print("pressedLoginBtn")
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
        self.loginBtn.alpha = 0
        self.loginBtn.isEnabled = false
//        pageControl.transform = CGAffineTransform(scaleX: 3, y: 1)
    }
}

// MARK: - 현재 페이지를 받음

extension IntroMainViewController: passCurrentPage {
    func passCurrentPage(page: Int) {
        currentPage.accept(page)
    }
    
    
}

