//
//  RegisterGenderViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/24.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RegisterGenderViewController: UIViewController {
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    
    var viewModel : RegisterViewModel?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.gender = nil
        registerGenderDesign()
        
        maleBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:  { [weak self] in
                self?.viewModel?.gender = .male
                self?.selectedBtn(button: self!.maleBtn, isSelected: true)
                self?.selectedBtn(button: self!.femaleBtn, isSelected: false)
                
                UIView.animate(withDuration: 0.5) {
                    self?.progress.setProgress(0.56, animated: true)
                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: true)
                }
            })
            .disposed(by: disposeBag)
        
        femaleBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:  { [weak self] in
                self?.viewModel?.gender = .female
                self?.selectedBtn(button: self!.femaleBtn, isSelected: true)
                self?.selectedBtn(button: self!.maleBtn, isSelected: false)
                
                UIView.animate(withDuration: 0.5) {
                    self?.progress.setProgress(0.56, animated: true)
                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: true)
                }
            })
            .disposed(by: disposeBag)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputInterest" {
            let destinationVC = segue.destination as? RegisterInterestViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    

    func selectedBtn(button: UIButton, isSelected: Bool) {
        button.layer.borderColor = isSelected == true ? UIColor.appColor(.system).cgColor : UIColor.appColor(.white235).cgColor
        button.isSelected = isSelected
    }
    

    @IBAction func pressedNextBtn(_ sender: Any) {
        // 성별을 선택하지 않았을 경우
        if viewModel?.gender == nil {
            let alert = AlertController(title: "성별을 선택해 주세요", message: "선택 후 다음으로 넘어갈 수 있습니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 성별을 선택했을 경우
        performSegue(withIdentifier: "InputInterest", sender: sender)
    }
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}


extension RegisterGenderViewController {
    func registerGenderDesign() {
        designFemaleMaleBtn()
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
    }
    
    func designFemaleMaleBtn() {
        femaleBtn?.layer.borderWidth = 2
        femaleBtn?.layer.borderColor = UIColor.appColor(.white235).cgColor
        femaleBtn?.layer.cornerRadius = 16
        
        maleBtn?.layer.borderWidth = 2
        maleBtn?.layer.borderColor = UIColor.appColor(.white235).cgColor
        maleBtn?.layer.cornerRadius = 16
    }
}
