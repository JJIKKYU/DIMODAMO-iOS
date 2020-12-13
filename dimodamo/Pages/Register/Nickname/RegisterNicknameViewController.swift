//
//  RegisterNicknameViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RegisterNicknameViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var certBtn: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameTextFieldSub: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var divide: UIView!
    
    var viewModel: RegisterViewModel?
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면이 로드될 경우에 키보드 올라오도록
        nickNameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        viewModel?.isVaildDuplicateNickName.accept(.nothing)
        

        nickNameTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel!.nickNameRelay)
            .disposed(by: disposeBag)
        
        viewModel?.nickNameRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] newValue in
                print("newValue : \(newValue)")
                
                // 글이 수정될 때마다 새로 인증을 받아야 하므로, 이메일 중복 확인 해제
                if self?.viewModel?.nickName != newValue {
                    self?.viewModel?.nickName = newValue
                    // 새로운 정보가 들어올 때마다 nothing으로 변경
                    self?.viewModel?.isVaildDuplicateNickName.accept(.nothing)
                }

//                print("\(self?.viewModel?.isValidNickname())")
                // 이메일 정규식에 알맞는 경우에는 중복확인 버튼 활성화
                if self?.viewModel?.isValidNickname() == true {
                    self?.certBtn.isEnabled = true
                    UIView.animate(withDuration: 0.5) {
                        self?.certBtn.backgroundColor = UIColor.appColor(.system)
                        self?.nickNameTextFieldSub.alpha = 0
                    }
                // 이메일 정규식에 맞지 않거나 그 외 조건에 맞지 않을 경우 중복확인 버튼 비활성화
                } else if self?.viewModel?.isValidNickname() == false {
                    self?.certBtn.isEnabled = false
                    UIView.animate(withDuration: 0.5) {
                        self?.nickNameTextFieldSub.alpha = 1
                        self?.certBtn.backgroundColor = UIColor.appColor(.gray210)
                    }
                }
        })	
        .disposed(by: disposeBag)
        
        viewModel?.isVaildDuplicateNickName
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                switch value {
                
                // 닉네임 사용이 가능할때
                case .possible:
                    let alert = AlertController(title: "사용 가능한 닉네임입니다", message: "남은 가입 단계를 계속 진행해 주세요", preferredStyle: .alert)
                    alert.setTitleImage(UIImage(named: "alertComplete"))
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        UIView.animate(withDuration: 0.5) {
                            self?.nextBtn.backgroundColor = UIColor.appColor(.system)
                            self?.checkIcon.alpha = 1
                            self?.certBtn.isEnabled = false
                            self?.certBtn.alpha = 0
                            self?.divide.backgroundColor = UIColor.appColor(.green3)
                            self?.progress.setProgress(0.8, animated: true)
                        }
                    }
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                    
                    break
                
                // 닉네임 사용이 불가능할때
                case .impossible:
                    let alert = AlertController(title: "다른 유저가 이미 사용 중입니다", message: "다른 닉네임을 입력해 주세요", preferredStyle: .alert)
                    alert.setTitleImage(UIImage(named: "alertError"))
                    let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                    
                    self?.viewModel?.isVaildDuplicateNickName.accept(.nothing)
                    
                    break
                    
                case .nothing:
                    UIView.animate(withDuration: 0.5) {
                        self?.divide.backgroundColor = UIColor.appColor(.gray210)
                        self?.certBtn.isEnabled = true
                        self?.certBtn.alpha = 1
                        self?.checkIcon.alpha = 0
                        self?.nextBtn.backgroundColor = UIColor.appColor(.gray210)
                        self?.progress.setProgress(0.64, animated: true)
                    }
                    break
                }
            })
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func moveUpTextView(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.nextBtn?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    @objc func moveDownTextView() {
        self.nextBtn?.transform = .identity
    }
    @IBAction func pressedCertBtn(_ sender: Any) {
        if self.viewModel?.isValidNickname() == false { return }
        viewModel?.duplicationCheckNickname()
    }
    
    @IBAction func pressNextBtn(_ sender: Any) {
        if viewModel?.isVailedNickName == false ||
            viewModel?.isVaildDuplicateNickName.value == NicknameCheck.nothing ||
            viewModel?.isVaildDuplicateNickName.value == NicknameCheck.impossible {
            
            let alert = AlertController(title: "닉네임을 입력해 주세요", message: "중복 확인 후 다음으로 넘어갈 수 있습니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        performSegue(withIdentifier: "InputSchool", sender: sender)
    }
    
    @IBAction func pressCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputSchool" {
            let destinationVC = segue.destination as? RegisterSchoolViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    

}


extension RegisterNicknameViewController {
    func viewDesign() {
        designNextBtn()
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
        checkIcon.alpha = 0
        nickNameTextFieldSub.alpha = 0
        certBtn.layer.cornerRadius = 4
        certBtn.isEnabled = false
    }
    
    func designNextBtn() {
        nextBtn?.backgroundColor = UIColor.appColor(.gray210)
//        nextBtn?.layer.cornerRadius = 16
    }
}
