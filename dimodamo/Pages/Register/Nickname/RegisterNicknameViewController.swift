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
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var checkIcon: UIImageView!
    
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

        nickNameTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel!.nickNameRelay)
            .disposed(by: disposeBag)
        
        viewModel?.nickNameRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] newValue in
                print("newValue : \(newValue)")
                
                self?.viewModel?.nickName = newValue
//                print(self?.viewModel?.userName)
                
                if self?.viewModel?.isVailedNickName == true {
                    UIView.animate(withDuration: 0.5) {
                        self?.checkIcon.alpha = 1
                        self?.progress.setProgress(0.84, animated: true)
                        AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: true)
                    }
                }else {
                    UIView.animate(withDuration: 0.5) {
                        self?.checkIcon.alpha = 0
                        self?.progress.setProgress(0.70, animated: true)
                        AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: false)
                    }
                }
        })
        .disposed(by: disposeBag)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @IBAction func pressNextBtn(_ sender: Any) {
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
    }
    
    func designNextBtn() {
        nextBtn?.backgroundColor = UIColor.appColor(.gray210)
        nextBtn?.layer.cornerRadius = 16
    }
}
