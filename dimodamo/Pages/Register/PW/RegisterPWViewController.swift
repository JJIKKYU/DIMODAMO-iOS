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
        self.view.layoutIfNeeded()

        firstPWTextField.rx.controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in

                let newValue = self!.firstPWTextField.text!
                self?.viewModel?.userFirstPWRelay.accept(newValue)
                
                // 패스워드 정규식에 넣어 유효한지 확인
                let isValied: Bool = (self?.viewModel!.isValidPassword(pw: newValue))!
                print(isValied)
                self?.viewModel?.isValidUserPW = isValied == true ? .onlyFirstTextfield : .nothing
                
                UIView.animate(withDuration: 0.5) {
                    self?.checkIcon.alpha = isValied == true ? 1 : 0
                    self?.firstDivide.backgroundColor = isValied == true ? UIColor.appColor(.green3) : UIColor.appColor(.white235)
                    self?.firstPWTextFieldSubTitle.alpha = isValied == true ? 0 : 1 // 비밀번호가 양식에 맞지 않습니다
                    self?.secondPWTextField.isEnabled = isValied
                }

            })
            .disposed(by: disposeBag)
        
        secondPWTextField.rx.controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in

                let firstTextFieldValue = self!.firstPWTextField.text!
                let newValue = self!.secondPWTextField.text!
                self?.viewModel?.userSecondPWRelay.accept(newValue)
                
                // 이미 정규식을 통해 유효한 패스워드와, 두번째 텍스트 필드의 값을 비교
                let isValied: Bool = newValue.count != 0 && firstTextFieldValue == newValue
                self?.viewModel?.isValidUserPW = isValied == true ? .possible : .onlyFirstTextfield
                
                UIView.animate(withDuration: 0.5) {
                    self?.checkIcon2.alpha = isValied == true ? 1 : 0
                    self?.secondDivide.backgroundColor = isValied == true ? UIColor.appColor(.green3) : UIColor.appColor(.white235)
                    self?.secondPWTextFieldSubTitle.alpha = isValied == true ? 0 : 1
                    
                    AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: isValied)
                    self?.progress.setProgress(isValied == true ? 0.48 : 0.32, animated: true)
                }

            })
            .disposed(by: disposeBag)
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputInterest" {
            let destinationVC = segue.destination as? RegisterInterestViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    
    @objc func moveUpTextView(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.nextBtn?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    @objc func moveDownTextView() {
        self.nextBtn?.transform = .identity
    }

    @IBAction func pressedNextBtn(_ sender: Any) {
        switch viewModel?.isValidUserPW {
        // 아무것도 입력하지 않았거나 기본 입력 상태인 경우
        case .nothing:
            let alert = AlertController(title: "비밀번호를 입력해 주세요", message: "한 번 더 확인 후 다음으로 넘어갈 수 있습니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            break
        
        // 첫번째 텍스트필드만 올바르게 입력한 경우
        case .onlyFirstTextfield:
            let alert = AlertController(title: "비밀번호를 정확하게 입력해 주세요", message: "한 번 더 확인 후 다음으로 넘어갈 수 있습니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            break
            
        // 패스워드 사용이 가능한 경우
        case .possible:
            performSegue(withIdentifier: "InputInterest", sender: sender)
            break
            
        case .none:
            break
        }
        
        
        
    }
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
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
        
        // 첫번째 텍스트필드 정규식을 통과하면 true로 변경할 예정
        secondPWTextField.isEnabled = false
    }
}
