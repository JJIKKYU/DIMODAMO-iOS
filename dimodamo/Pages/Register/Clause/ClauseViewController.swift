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
    
    // 필수 항목
    @IBOutlet weak var serviceBtn: UIButton!
    
    // 본인확인 서비스 이용약관
    @IBOutlet weak var serviceBtn2: UIButton!
    
    // 커뮤니티 이용 약관
    @IBOutlet weak var serviceBtn3: UIButton!
    
    @IBOutlet weak var markettingBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    
    var disposeBag = DisposeBag()
    let viewModel = RegisterViewModel()
    
    var nextBtnIsEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        Observable.combineLatest(
            viewModel.serviceBtnRelay.map { $0 == true },
            viewModel.serviceBtn2Relay.map { $0 == true },
            viewModel.serviceBtn3Relay.map { $0 == true }
        )
        .observeOn(MainScheduler.instance)
        .subscribe { [weak self] service1, service2, service3 in
            if (service1 == true && service2 && service3) {
                self?.nextBtnIsEnabled = true
                UIView.animate(withDuration: 0.5) {
                    self?.nextBtn.backgroundColor = UIColor.appColor(.systemActive)
                    self?.animateProgress(value: 0.14)
                }
            } else {
                self?.nextBtnIsEnabled = false
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
            viewModel.serviceBtn3Relay.map { $0 == true },
            viewModel.markettingBtnRelay.map { $0 == true }
        )
        .subscribe(onNext: { [weak self] btn1, btn2, btn3, marketingBtn in
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
        
        serviceBtn3.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                let flag: Bool = !((self?.serviceBtn3.isSelected)!)
                self?.viewModel.serviceBtn3Relay.accept(flag)
                self?.changeBtnColor(btn: self!.serviceBtn3, isSelected: flag)
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
                self?.changeBtnColor(btn: self!.serviceBtn3, isSelected: allBtnIsSelected)
                self?.changeBtnColor(btn: self!.markettingBtn, isSelected: allBtnIsSelected)
                
                self?.viewModel.serviceBtnRelay.accept(allBtnIsSelected)
                self?.viewModel.serviceBtn2Relay.accept(allBtnIsSelected)
                self?.viewModel.serviceBtn3Relay.accept(allBtnIsSelected)
                self?.viewModel.markettingBtnRelay.accept(allBtnIsSelected)
            })
            .disposed(by: disposeBag)
        
        
        
        
    }
    
    
    @IBAction func pressedNextBtn(_ sender: Any) {
        if nextBtnIsEnabled {
            performSegue(withIdentifier: "InputID", sender: sender)
        } else {
            let alert = AlertController(title: "필수 약관에 동의해 주세요", message: "동의 후 다음으로 넘어갈 수 있습니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 필수 항목 모두 동의
    @IBAction func pressedService1DetailBtn(_ sender: Any) {
        performSegue(withIdentifier: "ViewService1Clause", sender: sender)
    }
    
    // 본인확인 서비스 이용약관
    @IBAction func pressedService1Detai2Btn(_ sender: Any) {
        performSegue(withIdentifier: "ViewService2Clause", sender: sender)
    }
    
    // 커뮤니티 서비스 이용약관
    @IBAction func pressedService3Detail3Btn(_ sender: Any) {
        performSegue(withIdentifier: "ViewService3Clause", sender: sender)
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
