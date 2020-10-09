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



class FindEmailPWViewController: UIViewController, UIPageViewControllerDelegate {
    
    
    
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var pwBtn: UIButton!
    
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var underLineWidth: NSLayoutConstraint!
    @IBOutlet weak var underLineCenterX: NSLayoutConstraint!
    
    let viewModel = FindEmailPWViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        viewModel.isActiveEmailView
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.emailBtn.isSelected = value
                self?.pwBtn.isSelected = !value
                
                self?.underLine.translatesAutoresizingMaskIntoConstraints = false
                
                switch value {
                case true:
                    self?.underLineWidth.constant = 111
                    self?.underLineCenterX.constant = 0
                    
                    
                    print("true입니다")
                    break
                    
                case false:
                    self?.underLineWidth.constant = 131
                    self?.underLineCenterX.constant = 175
                    print("false입니다")
                    break
                    
                default:
                    break
                }
                self?.underLine.setNeedsUpdateConstraints()
                
                UIView.animate(withDuration: 0.5) {
                    self?.view.layoutIfNeeded()
                }
                
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

// MARK: - PageViewController에서 페이지 인덱스를 전달받는 델리게이트

extension FindEmailPWViewController : PageIndexDelegate {
    func SelectMenuItem(pageIndex: Int) {
        print("넘어옵니다")
        viewModel.isActiveEmailView.accept(pageIndex == 0 ? true : false)
    }
}
