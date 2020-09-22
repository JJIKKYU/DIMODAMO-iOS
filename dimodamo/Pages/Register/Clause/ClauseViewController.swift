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
        
        Observable.combineLatest(
            viewModel.serviceBtnRelay.map { $0 == true },
            viewModel.serviceBtn2Relay.map { $0 == true }
        )
        .observeOn(MainScheduler.instance)
        .subscribe { [weak self] service1, service2 in
            if (service1 == true && service2) {
                self?.nextBtn.isEnabled = true
                self?.nextBtn.backgroundColor = UIColor.appColor(.systemActive)
                self?.animateProgress(value: 0.14)
            } else {
                self?.nextBtn.isEnabled = false
                self?.nextBtn.backgroundColor = UIColor.appColor(.systemUnactive)
                self?.animateProgress(value: 0.01)
            }
        }
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel.serviceBtnRelay.map { $0 == true },
            viewModel.serviceBtn2Relay.map { $0 == true },
            viewModel.markettingBtnRelay.map { $0 == true }
        ) { $0 && $1 && $2}
        .bind(to: allBtn.rx.isSelected)
        .disposed(by: disposeBag)
        
        serviceBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                let flag: Bool = !((self?.serviceBtn.isSelected)!)
                self?.viewModel.serviceBtnRelay.accept(flag)
                self?.serviceBtn.isSelected = flag
            })
            .disposed(by: disposeBag)
        
        serviceBtn2.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                let flag: Bool = !((self?.serviceBtn2.isSelected)!)
                self?.viewModel.serviceBtn2Relay.accept(flag)
                self?.serviceBtn2.isSelected = flag
            })
            .disposed(by: disposeBag)
        
        markettingBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let flag: Bool = !((self?.markettingBtn.isSelected)!)
                self?.viewModel.markettingBtnRelay.accept(flag)
                self?.markettingBtn.isSelected = flag
            })
            .disposed(by: disposeBag)
    
        
        allBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                self?.allBtn.isSelected = self?.allBtn.isSelected == true ? false : true
                let allBtnIsSelected: Bool = self?.allBtn.isSelected == true ? true : false
                
                self?.serviceBtn.isSelected = allBtnIsSelected
                self?.serviceBtn2.isSelected = allBtnIsSelected
                self?.markettingBtn.isSelected = allBtnIsSelected
                
                self?.viewModel.serviceBtnRelay.accept(allBtnIsSelected)
                self?.viewModel.serviceBtn2Relay.accept(allBtnIsSelected)
                self?.viewModel.markettingBtnRelay.accept(allBtnIsSelected)
            })
            .disposed(by: disposeBag)

        
        
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
        AppStyleGuide.navigationBarWhite(navController: self.navigationController!)
        AppStyleGuide.navBarOrange(navigationController: self.navigationController!)
    }
    
    
    @IBAction func pressedNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputName", sender: sender)
    }
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func animateProgress(value: Float) {
        UIView.animate(withDuration: 0.5) {
            self.progress.setProgress(value, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputName" {
            let destinationVC = segue.destination as? RegisterNameViewController
            destinationVC?.viewModel = self.viewModel
        }
    }

}
