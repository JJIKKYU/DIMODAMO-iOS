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
    
    var viewModel : RegisterViewModel?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerGenderDesign()
        
        maleBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:  { [weak self] in
                self?.selectedBtn(button: self!.maleBtn, isSelected: true)
                self?.selectedBtn(button: self!.femaleBtn, isSelected: false)
            })
            .disposed(by: disposeBag)
        
        femaleBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:  { [weak self] in
                self?.selectedBtn(button: self!.femaleBtn, isSelected: true)
                self?.selectedBtn(button: self!.maleBtn, isSelected: false)
            })
            .disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputInterest" {
            let destinationVC = segue.destination as? RegisterGenderViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    

    func selectedBtn(button: UIButton, isSelected: Bool) {
        button.layer.borderColor = isSelected == true ? UIColor.appColor(.gray190).cgColor : UIColor.appColor(.white235).cgColor
        button.isSelected = isSelected
    }
    

    @IBAction func pressedNextBtn(_ sender: Any) {
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
