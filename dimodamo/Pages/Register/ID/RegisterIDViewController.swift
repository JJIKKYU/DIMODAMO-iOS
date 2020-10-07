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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewSubTitle: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldSubTitle: UILabel!
    @IBOutlet weak var divideLine: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var checkMark: UIImageView!
    
    @IBOutlet weak var emailCertBtn1: UIButton!
    
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
        
        viewModel?.userEmailRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] newValue in
                // 글이 수정될 때마다 새로 인증을 받아야 하므로, 이메일 중복 확인 해제
                if self?.viewModel?.prevUserEmail != newValue {
                    self?.viewModel?.prevUserEmail = newValue
                    self?.viewModel?.isVailedUserEmail.accept(.none)
                }
                
                // 이메일 정규식에 맞다면
                if self?.viewModel?.isValidEmail() == true {
                    // 중복확인 버튼 활성화
                    self?.emailCertBtn1.isEnabled = true
                    
                    UIView.animate(withDuration: 0.5) {
                        self?.textFieldSubTitle.alpha = 0
                        self?.emailCertBtn1.backgroundColor = UIColor.appColor(.system)
                    }
                // 이메일 정규식에 맞지 않다면
                } else {
                    // 중복확인 버튼 비활성화
                    self?.emailCertBtn1.isEnabled = false
                    UIView.animate(withDuration: 0.5) {
                        if newValue.count > 3 { self?.textFieldSubTitle.alpha = 1 }
                        self?.emailCertBtn1.backgroundColor = UIColor.appColor(.gray210)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        viewModel?.isVailedUserEmail
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                
                switch value {
                // 사용가능한 메일
                case .possible:
                    let alert = AlertController(title: "사용 가능한 메일입니다", message: "남은 가입 단계를 계속 진행해 주세요", preferredStyle: .alert)
                    alert.setTitleImage(UIImage(named: "alertComplete"))
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        UIView.animate(withDuration: 0.5) {
                            self?.nextBtn.backgroundColor = UIColor.appColor(.system)
                            self?.checkMark.alpha = 1
                            self?.emailCertBtn1.alpha = 0
                            self?.emailCertBtn1.isEnabled = false
                            self?.divideLine.backgroundColor = UIColor.appColor(.green3)
                        }
                    }
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                    
                // 사용 불가능한 메일
                case .impossible:
                    let alert = AlertController(title: "이미 가입되어 있는 메일입니다", message: "로그인이나 비밀번호 찾기를 이용해 주세요", preferredStyle: .alert)
                    alert.setTitleImage(UIImage(named: "alertError"))
                    let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                
                // 인증 해제 및 인증 받지 않은 상태
                case .none:
                    UIView.animate(withDuration: 0.5) {
                        self?.nextBtn.backgroundColor = UIColor.appColor(.gray210)
                        self?.checkMark.alpha = 0
                        self?.divideLine.backgroundColor = UIColor.appColor(.white235)
                        self?.emailCertBtn1.alpha = 1
                    }
                    break
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
            self.nextBtn?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    @objc func moveDownTextView() {
        self.nextBtn?.transform = .identity
    }
    
    // MARK: - Navigation
    
    @IBAction func pressedNextBtn(_ sender: Any) {
        // 중복확인 결과 생성 가능한 이메일이 아닐 경우에 팝업
        if viewModel?.isVailedUserEmail.value != .possible {
            let alert = AlertController(title: "이메일을 입력해 주세요", message: "중복 확인 후 다음으로 넘어갈 수 있습니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        // 중복확인 결과 생성 가능한 이메일일 경우 다음으로
        } else {
            performSegue(withIdentifier: "InputPW", sender: sender)
        }
        
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 중복 확인
    @IBAction func pressCertBtn1(_ sender: Any) {
        
        viewModel?.emailExistCheck()
    }
    
}

extension RegisterIDViewController {
    func viewDesign() {
        changeHeightContentView()
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
        emailCertBtn1.layer.cornerRadius = 4
        textFieldSubTitle.alpha = 0
        checkMark.alpha = 0
        divideLine.backgroundColor = UIColor.appColor(.white235)
        emailCertBtn1.isEnabled = false
    }
    
    func changeHeightContentView() {
        print(UIScreen.main.bounds.height)
        let window = UIApplication.shared.keyWindow
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        print(", \(bottomPadding), \(topBarHeight)")
        let heightScreen: CGFloat = UIScreen.main.bounds.height - bottomPadding - topBarHeight
        contentViewHeight.constant = heightScreen
        contentViewHeight.isActive = true
    }
}
