//
//  FindPWViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FindPWViewController: UIViewController {

    @IBOutlet weak var schoolIdTextField: UITextField!
    @IBOutlet weak var schoolIdLine: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLine: UIView!
    
    @IBOutlet weak var findBtn: UIButton!
    
    let viewModel = FindPWViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        schoolIdTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.userSchoolIdRelay)
            .disposed(by: disposeBag)
        
        viewModel.userSchoolIdRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                
            })
            .disposed(by: disposeBag)
        
        
        emailTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.userEmailRelay)
            .disposed(by: disposeBag)
        
        viewModel.userEmailRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                print(self?.viewModel.userEmailRelay.value)
            })
            .disposed(by: disposeBag)
        
        viewModel.isValiedUserEmail
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                
                switch value {
                // 사용가능한 메일
                case .possible:
                    let alert = AlertController(title: "이메일 발송 완료", message: "전송된 이메일을 통해 비밀번호를 재설정 해주세요", preferredStyle: .alert)
                    alert.setTitleImage(UIImage(named: "alertComplete"))
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                    
                // 사용 불가능한 메일
                case .impossible:
                    let alert = AlertController(title: "위 정보와 일치하는 이메일이 없습니다", message: "이메일과 학번을 올바르게 입력해주세요", preferredStyle: .alert)
                    alert.setTitleImage(UIImage(named: "alertError"))
                    let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                
                // 인증 해제 및 인증 받지 않은 상태
                case .none:
                    UIView.animate(withDuration: 0.5) {
//                        self?.nextBtn.backgroundColor = UIColor.appColor(.gray210)
//                        self?.checkMark.alpha = 0
//                        self?.divideLine.backgroundColor = UIColor.appColor(.white235)
//                        self?.emailCertBtn1.alpha = 1
                    }
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 터치했을때 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func pressedFindBtn(_ sender: Any) {
        viewModel.sendPasswordResetMail()
    }
}

extension FindPWViewController {
    func viewDesign() {
        findBtn.layer.cornerRadius = 16
    }
    
}
