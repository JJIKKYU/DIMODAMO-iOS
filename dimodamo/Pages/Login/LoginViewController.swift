
//  LoginViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

//import KakaoSDKAuth

import FirebaseAuth

class LoginViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var loginCheckLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            loginCheckLabel.text = "이미 로그인 중입니다"
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func pressLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: pwTextField.text!,
                           completion: {user, error in
                            if user != nil {
                                print("loginSucess")
                                self.loginCheckLabel.text = "로그인 성공"
                            } else {
                                print("loginFail")
                            }
        })
    }
    @IBAction func pressLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
          } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
          }
        print("로그아웃이 완료되었습니다")
        loginCheckLabel.text = "로그아웃 상태"
    }
    
    @IBAction func pressedRegisterBtn(_ sender: Any) {
        let registerStoryboard = UIStoryboard(name: "Register", bundle: nil)
        let registerVC = registerStoryboard.instantiateViewController(withIdentifier: "RegisterVC")
        
//        let registerVC: UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginMain")
//
//        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: registerVC)
//
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }
    
    //    @IBAction func pressKakaoLogin(_ sender: Any) {
//
//        AuthApi.shared.rx.loginWithKakaoAccount()
//            .subscribe(onNext:{ (oauthToken) in
//                print("loginWithKakaoAccount() success.")
//
//                //do something
//                _ = oauthToken
//            }, onError: {error in
//                print(error)
//            })
//            .disposed(by: disposeBag)
//
//    }
    
    @IBAction func pressCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
