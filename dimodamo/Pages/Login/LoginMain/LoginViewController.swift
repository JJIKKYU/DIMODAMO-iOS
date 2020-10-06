
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
    
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var loginCheckLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var arrowBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        if let user = Auth.auth().currentUser {
            loginCheckLabel.text = "이미 로그인 중입니다"
        }
        
        // Do any additional setup after loading the view.
    }
    
    // 터치했을때 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func pressLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: pwTextField.text!,
                           completion: {user, error in
                            if let error = error as NSError? {
                                switch AuthErrorCode(rawValue: error.code) {
                                case .operationNotAllowed:
                                    print("operationNotAllowed")
                                    break
                                    
                                case .userDisabled:
                                    print("userDisabled")
                                    break
                                    
                                case .wrongPassword:
                                    print("wrongPassword")
                                    let alert = AlertController(title: "비밀번호가 일치하지 않습니다", message: "비밀번호 찾기를 이용해 주세요", preferredStyle: .alert)
                                    alert.setTitleImage(UIImage(named: "alertError"))
                                    let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                    break
                                    
                                case .invalidEmail:
                                    print("invalidEmail")
                                    break
                                    
                                case .missingEmail:
                                    print("mssingEmail")
                                    break
                                    
                                case .userNotFound:
                                    print("userNotFound")
                                    break
                                    
                                default:
                                    print("ErorCode : \(error)")
                                    print("Error: \(error.localizedDescription)")
                                    break
                                }
                            } else {
                                print("loginSucess")
                                self.loginCheckLabel.text = "로그인 성공"
                                self.presentMainScreen()
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
    
    func presentMainScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        
        //        let registerVC: UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginMain")
        //
        //        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: registerVC)
        //
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
    
    @IBAction func pressCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedFindPWBtn(_ sender: Any) {
        performSegue(withIdentifier: "FindEmailPWVC", sender: sender)
    }
    
    @IBAction func pressedFindEmailBtn(_ sender: Any) {
        performSegue(withIdentifier: "FindEmailPWVC", sender: sender)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindEmailPWVC" {
            let button: UIButton = sender as! UIButton
            let destinationVC = segue.destination as? FindEmailPWViewController
            
            switch button.tag {
            // 이메일 찾기
            case 0:
                destinationVC?.viewModel.isActiveEmailView.accept(true)
                break
                
            // 비밀번호 찾기
            case 1:
                destinationVC?.viewModel.isActiveEmailView.accept(false)
                break
            default:
                break
            }
            
        }
    }
    
    
}

extension LoginViewController {
    func viewDesign() {
        roundView.roundCorners(corners: [.topLeft, .topRight], radius: 24)
        loginBtn.layer.cornerRadius = 4
        registerBtn.layer.cornerRadius = 4
        arrowBtn.layer.cornerRadius = 24
        
        loginTitle.appShadow(.s8)
        arrowBtn.appShadow(.s12)
    }
}

// 탑 라운드 코너할 때 사용
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
