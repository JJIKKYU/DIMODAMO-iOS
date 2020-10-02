//
//  ClauseViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/22.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ClauseViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIBarButtonItem!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var serviceBtn: UIButton!
    
    
    @IBOutlet weak var serviceBtn2: UIButton!
    @IBOutlet weak var markettingBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    
    var disposeBag = DisposeBag()
    let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        Observable.combineLatest(
            viewModel.serviceBtnRelay.map { $0 == true },
            viewModel.serviceBtn2Relay.map { $0 == true }
        )
        .observeOn(MainScheduler.instance)
        .subscribe { [weak self] service1, service2 in
            if (service1 == true && service2) {
                self?.nextBtn.isEnabled = true
                UIView.animate(withDuration: 0.5) {
                    self?.nextBtn.backgroundColor = UIColor.appColor(.systemActive)
                    self?.animateProgress(value: 0.14)
                }
            } else {
                self?.nextBtn.isEnabled = false
                UIView.animate(withDuration: 0.5) {
                    self?.nextBtn.backgroundColor = UIColor.appColor(.gray210)
                    self?.animateProgress(value: 0.01)
                }
            }
        }
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel.serviceBtnRelay.map { $0 == true },
            viewModel.serviceBtn2Relay.map { $0 == true },
            viewModel.markettingBtnRelay.map { $0 == true }
        )
        .subscribe(onNext: { [weak self] btn1, btn2, btn3 in
            if btn1 && btn2 && btn3 {
                self?.changeBtnColorAllBtn(btn: self!.allBtn, isSelected: true)
            } else {
                self?.changeBtnColorAllBtn(btn: self!.allBtn, isSelected: false)
            }
        })
        .disposed(by: disposeBag)
        
        serviceBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                let flag: Bool = !((self?.serviceBtn.isSelected)!)
                self?.viewModel.serviceBtnRelay.accept(flag)
                self?.changeBtnColor(btn: self!.serviceBtn, isSelected: flag)
            })
            .disposed(by: disposeBag)
        
        serviceBtn2.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                let flag: Bool = !((self?.serviceBtn2.isSelected)!)
                self?.viewModel.serviceBtn2Relay.accept(flag)
                self?.changeBtnColor(btn: self!.serviceBtn2, isSelected: flag)
            })
            .disposed(by: disposeBag)
        
        markettingBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let flag: Bool = !((self?.markettingBtn.isSelected)!)
                self?.viewModel.markettingBtnRelay.accept(flag)
                self?.changeBtnColor(btn: self!.markettingBtn, isSelected: flag)
            })
            .disposed(by: disposeBag)
    
        
        allBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                self?.allBtn.isSelected = self?.allBtn.isSelected == true ? false : true
                let allBtnIsSelected: Bool = self?.allBtn.isSelected == true ? true : false
                
                self?.changeBtnColor(btn: self!.serviceBtn, isSelected: allBtnIsSelected)
                self?.changeBtnColor(btn: self!.serviceBtn2, isSelected: allBtnIsSelected)
                self?.changeBtnColor(btn: self!.markettingBtn, isSelected: allBtnIsSelected)
                
                self?.viewModel.serviceBtnRelay.accept(allBtnIsSelected)
                self?.viewModel.serviceBtn2Relay.accept(allBtnIsSelected)
                self?.viewModel.markettingBtnRelay.accept(allBtnIsSelected)
            })
            .disposed(by: disposeBag)

        
        
        
    }
    
    
    @IBAction func pressedNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputID", sender: sender)
    }
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedService1DetailBtn(_ sender: Any) {
        performSegue(withIdentifier: "ViewService1Clause", sender: sender)
    }
    
    func animateProgress(value: Float) {
        UIView.animate(withDuration: 0.5) {
            self.progress.setProgress(value, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputID" {
            let destinationVC = segue.destination as? RegisterIDViewController
            destinationVC?.viewModel = self.viewModel
        }
    }

}


extension ClauseViewController {
    func viewDesign() {
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
        AppStyleGuide.navigationBarWhite(navController: self.navigationController!)
        AppStyleGuide.navBarOrange(navigationController: self.navigationController!)
    }
    
    func changeBtnColor(btn: UIButton, isSelected: Bool) {
        btn.isSelected = isSelected
        
        if isSelected == true {
            btn.tintColor = UIColor.appColor(.green3)
        } else {
            btn.tintColor = UIColor.appColor(.gray170)
        }
    }
    
    func changeBtnColorAllBtn(btn: UIButton, isSelected: Bool) {
        btn.isSelected = isSelected
        
        if isSelected == true {
            btn.tintColor = UIColor.appColor(.green1)
        } else {
            btn.tintColor = UIColor.appColor(.gray170)
        }
    }
}
