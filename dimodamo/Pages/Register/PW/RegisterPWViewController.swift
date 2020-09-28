//
//  RegisterPWViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class RegisterPWViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var checkIcon2: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var firstPWTextField: UITextField!
    @IBOutlet weak var secondPWTextField: UITextField!
    
    @IBOutlet weak var firstPWTextFieldSubTitle: UILabel!
    @IBOutlet weak var secondPWTextFieldSubTitle: UILabel!
    
    @IBOutlet weak var firstDivide: UIView!
    @IBOutlet weak var secondDivide: UIView!
    
    
    var viewModel : RegisterViewModel?
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // 화면이 로드될 경우에 키보드 올라오도록
        firstPWTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()

        firstPWTextField.rx.controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in

                let newValue = self!.firstPWTextField.text!
                self?.viewModel?.userFirstPWRelay.accept(newValue)
                
                let isValied: Bool = (self?.viewModel!.isValidPassword(pw: newValue))!
                print(isValied)
                
                UIView.animate(withDuration: 0.5) {
                    self?.checkIcon.alpha = isValied == true ? 1 : 0
                    self?.firstDivide.backgroundColor = isValied == true ? UIColor.appColor(.green3) : UIColor.appColor(.white235)
                    self?.firstPWTextFieldSubTitle.alpha = isValied == true ? 0 : 1
                }

            })
            .disposed(by: disposeBag)
        
        secondPWTextField.rx.controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in

                let firstTextFieldValue = self!.firstPWTextField.text!
                let newValue = self!.secondPWTextField.text!
                self?.viewModel?.userSecondPWRelay.accept(newValue)
                
                let isValied: Bool = newValue.count != 0 && firstTextFieldValue == newValue
                
                print(isValied)
                
                UIView.animate(withDuration: 0.5) {
                    self?.checkIcon2.alpha = isValied == true ? 1 : 0
                    self?.secondDivide.backgroundColor = isValied == true ? UIColor.appColor(.green3) : UIColor.appColor(.white235)
                    self?.secondPWTextFieldSubTitle.alpha = isValied == true ? 0 : 1
                    
                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: isValied)
                    self?.progress.setProgress(isValied == true ? 0.42 : 0.28, animated: true)
                }

            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel!.userFirstPWRelay.map { $0},
            viewModel!.userSecondPWRelay.map { $0}
            )
        .observeOn(MainScheduler.instance)
        .subscribe { [weak self] firstPW, secondPW in
            
            
            
//            guard self?.viewModel?.isValidPassword() == true else { return }
            
            
//            if self?.viewModel?.isValidPassword(pw: String(secondPW)) == true &&
//                self?.viewModel?.userFirstPWRelay.value == self?.viewModel?.userSecondPWRelay.value {
//                self?.checkIcon2.alpha = 1
//                self?.secondPWTextFieldSubTitle.alpha = 0
//                self?.secondDivide.backgroundColor = UIColor.appColor(.green3)
//
//                UIView.animate(withDuration: 0.5) {
//                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: true)
//                    self?.progress.setProgress(0.42, animated: true)
//                }
//
//
//            } else if self?.viewModel?.isValidPassword(pw: String(secondPW)) == true {
//                self?.checkIcon2.alpha = 0
//                self?.secondPWTextFieldSubTitle.alpha = 1
//                self?.secondDivide.backgroundColor = UIColor.appColor(.white235)
//
//                UIView.animate(withDuration: 0.5) {
//                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: false)
//                    self?.progress.setProgress(0.28, animated: true)
//                }
//            } else {
//                print("아무것도 아닙니다")
//            }
            
//            if firstPW.count != 0 && firstPW == secondPW {
//                print("사용가능한 패스워드입니다")
//
//                UIView.animate(withDuration: 0.5) {
//                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: true)
//                    self?.progress.setProgress(0.42, animated: true)
//                }
//            } else {
//                print("패스워드가 일치하지 않습니다.")
//
//                UIView.animate(withDuration: 0.5) {
//                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: false)
//                    self?.progress.setProgress(0.28, animated: true)
//                }
//            }
        }
        .disposed(by: disposeBag)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputGender" {
            let destinationVC = segue.destination as? RegisterGenderViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    
    @objc func moveUpTextView(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0, animations: {
                            self.nextBtn?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            })
        }
    }
    
    @objc func moveDownTextView() {
        self.nextBtn?.transform = .identity
    }

    @IBAction func pressedNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputGender", sender: sender)
    }
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegisterPWViewController {
    
    func viewDesign() {
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
        checkIcon.alpha = 0
        checkIcon2.alpha = 0
        firstPWTextFieldSubTitle.alpha = 0
        secondPWTextFieldSubTitle.alpha = 0
        firstDivide.backgroundColor = UIColor.appColor(.white235)
        secondDivide.backgroundColor = UIColor.appColor(.white235)
    }
}
