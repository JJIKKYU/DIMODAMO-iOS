//
//  FindEmailPWViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa



class FindEmailPWViewController: UIViewController, UIPageViewControllerDelegate, PageIndexDelegate {
    func SelectMenuItem(pageIndex: Int) {
        print("넘어옵니다")
        viewModel.isActiveEmailView.accept(pageIndex == 0 ? true : false)
    }
    
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var pwBtn: UIButton!
    
    @IBOutlet weak var emailUnderLine: UIView!
    @IBOutlet weak var pwUnderLine: UIView!
    
    let viewModel = FindEmailPWViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        viewModel.isActiveEmailView
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                print(value)
                
//                self?.emailView.isHidden = value
                self?.emailBtn.isSelected = value
//                self?.pwView.isHidden = !value
                self?.pwBtn.isSelected = !value
                
                self?.emailUnderLine.alpha = value == true ? 1 : 0
                self?.pwUnderLine.alpha = value == true ? 0 : 1
                
            })
            .disposed(by: disposeBag)
        
    }
    
    
    @IBAction func pressedEmailBtn(_ sender: Any) {
        viewModel.isActiveEmailView.accept(true)
    }
    
    @IBAction func pressedPWBtn(_ sender: Any) {
        viewModel.isActiveEmailView.accept(false)
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedVC" {
            print("앙")
            let destinationVC: FindEmailPWPageViewController = segue.destination as! FindEmailPWPageViewController
            destinationVC.pageDelegate = self
        }
    }
}

extension FindEmailPWViewController {
    func viewDesign() {
//        self.pwView.isHidden = true
    }
}
