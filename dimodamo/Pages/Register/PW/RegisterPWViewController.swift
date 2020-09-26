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
    @IBOutlet weak var firstPWTextField: UITextField!
    @IBOutlet weak var secondPWTextField: UITextField!
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var checkIcon2: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    
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

                self?.viewModel?.userFirstPWRelay.accept(self!.firstPWTextField.text!)

            })
            .disposed(by: disposeBag)
        
        secondPWTextField.rx.controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.userSecondPWRelay.accept(self!.secondPWTextField.text!)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel!.userFirstPWRelay.map { $0},
            viewModel!.userSecondPWRelay.map { $0}
            )
        .observeOn(MainScheduler.instance)
        .subscribe { [weak self] firstPW, secondPW in
//            guard self?.viewModel?.isValidPassword() == true else { return }
            if self?.viewModel?.isValidPassword(pw: String(firstPW)) == true {
                self?.checkIcon.alpha = 1
            } else {
                self?.checkIcon.alpha = 0
            }
            
            if self?.viewModel?.isValidPassword(pw: String(secondPW)) == true {
                self?.checkIcon2.alpha = 1
            } else {
                self?.checkIcon2.alpha = 0
            }
            
            if firstPW.count != 0 && firstPW == secondPW {
                print("사용가능한 패스워드입니다")
                
                UIView.animate(withDuration: 0.5) {
                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: true)
                    self?.progress.setProgress(0.42, animated: true)
                }
            } else {
                print("패스워드가 일치하지 않습니다.")
                
                UIView.animate(withDuration: 0.5) {
                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: false)
                    self?.progress.setProgress(0.28, animated: true)
                }
            }
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
    }
}
