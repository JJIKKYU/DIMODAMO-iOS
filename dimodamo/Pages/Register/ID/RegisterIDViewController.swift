//
//  RegisterIDViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import MessageUI

class RegisterIDViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewSubTitle: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var codeTextfield: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var emailCertBtn1: UIButton!
    @IBOutlet weak var emailCertBtn2: UIButton!
    
    @IBOutlet weak var divideLine2: UIView!
    
    var viewModel : RegisterViewModel? = nil
    var disposeBag = DisposeBag()
    
    // 스크린이 로드 되기 전에 키보드 미리 올려놓기
    override func viewWillAppear(_ animated: Bool) {
        self.textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        textField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel!.userEmailRelay)
            .disposed(by: disposeBag)
        
        codeTextfield.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel!.userEmailVerifyCodeRelay)
            .disposed(by: disposeBag)
        
        viewModel?.userEmailRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] newValue in
                //                self?.viewModel!.nameRelay.accept(newValue)
                print("newValue : \(newValue)")
                
                self?.viewModel?.userEmail = newValue
                //                print(self?.viewModel?.userName)
                
                if self?.viewModel?.isValidEmail() == true {
                    self?.emailCertBtn1.isEnabled = true
                    UIView.animate(withDuration: 0.5) {
                        self?.emailCertBtn1.backgroundColor = UIColor.appColor(.system)
                    }
                }else {
                    self?.emailCertBtn1.isEnabled = false
                    UIView.animate(withDuration: 0.5) {
                        self?.emailCertBtn1.backgroundColor = UIColor.appColor(.gray210)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.userEmailVerifyCodeRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                self?.viewModel?.userEmailVerifyCode = newValue
                print(self?.viewModel?.userEmailVerifyCode)
                
                if self?.viewModel?.emailVerifyCode == self?.viewModel?.userEmailVerifyCode {
                    self?.viewModel?.verifyCodeIsValied = true
                } else {
                    self?.viewModel?.verifyCodeIsValied = false
                }
            })
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    } 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputPW" {
            let destinationVC = segue.destination as? RegisterPWViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    
    // 키보드 업, 다운 관련
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Navigation
    
    @IBAction func pressedNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputPW", sender: sender)
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 전송 요청
    @IBAction func pressCertBtn1(_ sender: Any) {
        viewModel?.sendVerifyEmail()
        emailCertBtn1.setTitle("다시 요청", for: .normal)
        verifyTextfiled(enabled: true)
        print(viewModel?.emailVerifyCode)
        
        viewTitle.text = "인증 코드를 입력해 주세요!"
        viewSubTitle.text = "인증번호는 최대 5분간 유효"
        
        UIView.animate(withDuration: 0.5) {
            self.emailCertBtn2.backgroundColor = UIColor.appColor(.system)
            self.emailCertBtn2.isEnabled = true
        }
        
        // 출결번호 보내기
    }
    
    // 인증요청
    @IBAction func pressCertBtn2(_ sender: Any) {
        alertVerify(isComplete: viewModel!.verifyCodeIsValied)
    }
    
}

extension RegisterIDViewController {
    func viewDesign() {
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
        emailCertBtn1.layer.cornerRadius = 4
        emailCertBtn2.layer.cornerRadius = 4
        emailCertBtn2.isEnabled = false
        
        codeTextfield.alpha = 0
        codeTextfield.isEnabled = false
        divideLine2.alpha = 0
        emailCertBtn2.isEnabled = false
        emailCertBtn2.alpha = 0
        
    }
    
    func verifyTextfiled(enabled: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.emailCertBtn2.alpha = enabled == true ? 1 : 0
            self.codeTextfield.alpha = enabled == true ? 1 : 0
            self.divideLine2.alpha = enabled == true ? 1 : 0
        }
        emailCertBtn2.isEnabled = enabled
        codeTextfield.isEnabled = enabled
        
    }
    
    func alertVerify(isComplete: Bool) {
        
        if isComplete == true {
            
            let alert = AlertController(title: "인증이 완료되었습니다", message: "남은 가입 단계를 계속 진행해 주세요", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertComplete"))
            alert.view.tintColor = UIColor.appColor(.green2)
            // Add actions
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                self.nextBtn.isEnabled = true
                self.textField.isEnabled = false
                self.codeTextfield.isEnabled = false
                self.emailCertBtn1.isEnabled = false
                self.emailCertBtn2.isEnabled = false
                UIView.animate(withDuration: 0.5) {
                    AppStyleGuide.systemBtnRadius16(btn: self.nextBtn, isActive: true)
                    self.progress.setProgress(0.28, animated: true)
                }
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            
            let alert = AlertController(title: "번호가 옳지 않습니다", message: "인증번호 요청을 다시 진행해 주세요", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            // Add actions
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    
}
