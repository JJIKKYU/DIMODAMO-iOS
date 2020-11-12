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
    
    var btnDelegate: BtnPageIndexDelegate?
    
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
        btnDelegate?.SelectMenuBtn(BtnIndex: 0)
        
    }
    
    @IBAction func pressedPWBtn(_ sender: Any) {
        viewModel.isActiveEmailView.accept(false)
        btnDelegate?.SelectMenuBtn(BtnIndex: 1)
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedVC" {
            let destinationVC: FindEmailPWPageViewController = segue.destination as! FindEmailPWPageViewController
            destinationVC.pageDelegate = self
            btnDelegate = destinationVC
            let index = viewModel.isActiveEmailView.value == true ? 0 : 1
            destinationVC.pageIndex.accept(index)
        }
    }
}

extension FindEmailPWViewController {
    func viewDesign() {
        underLine.layer.cornerRadius = 2
        //        self.pwView.isHidden = true
    }
}

// MARK: - PageViewController에서 페이지 인덱스를 전달받는 델리게이트 (데이터를 받음)

extension FindEmailPWViewController : PageIndexDelegate {
    func SelectMenuItem(pageIndex: Int) {
        viewModel.isActiveEmailView.accept(pageIndex == 0 ? true : false)
    }
}

// MARK: - 이메일 찾기, 비밀번호 찾기를 눌렀을 경우 인덱스를 전달하는 델리게이트 (데이터를 보냄)

protocol BtnPageIndexDelegate {
    func SelectMenuBtn(BtnIndex: Int)
}

