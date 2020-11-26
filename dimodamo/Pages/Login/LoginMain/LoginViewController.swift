
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
    
    
    
    @IBOutlet weak var welcomeTitleBottomConstraint: NSLayoutConstraint! {
        didSet {
            if UIScreen.main.bounds.height < 700 {
                self.welcomeTitleBottomConstraint.constant = 0
            }
        }
    }
    @IBOutlet weak var loginTitle: UILabel! {
        didSet {
            loginTitle.textColor = UIColor.appColor(.system)
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var emailSubTitle: UILabel!
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwLine: UIView!
    @IBOutlet weak var pwSubTitle: UILabel!
    
    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var findEmailBtn: UIView! {
        didSet {
            // 미구현으로 숨김 처리
            findEmailBtn.isHidden = true
        }
    }
    @IBOutlet weak var findPwBtn: UIButton! {
        didSet {
            // 미구현으로 숨김 처리
            findPwBtn.isHidden = true
        }
    }
    
    
    var viewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        emailTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.userEmailRelay)
            .disposed(by: disposeBag)
        
        viewModel.userEmailRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                
                UIView.animate(withDuration: 0.5) {
                    // 이메일 양식에 맞지 않다면
                    if self?.viewModel.isValidEmail() == false && newValue.count > 3 {
                        self?.emailSubTitle.alpha = 1
                        self?.emailLine.backgroundColor = UIColor.appColor(.red)
                        // 이메일 양식에 맞다면
                    } else if self?.viewModel.isValidEmail() == true && newValue.count > 3 {
                        self?.emailSubTitle.alpha = 0
                        self?.emailLine.backgroundColor = UIColor.appColor(.system)
                    }
                    // 그 외
                    else {
                        self?.emailSubTitle.alpha = 0
                        self?.emailLine.backgroundColor = UIColor.appColor(.gray210)
                    }
                }
                
            })
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.userPwRelay)
            .disposed(by: disposeBag)
        
        viewModel.userPwRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                
                UIView.animate(withDuration: 0.5) {
                    // 패스워드 양식에 안맞다면
                    if self?.viewModel.isValidPassword() == false && newValue.count > 3 {
                        self?.pwSubTitle.alpha = 1
                        self?.pwLine.backgroundColor = UIColor.appColor(.red)
                    // 패스워드 양식에 맞다면
                    } else if self?.viewModel.isValidPassword() == true && newValue.count > 3 {
                        self?.pwSubTitle.alpha = 0
                        self?.pwLine.backgroundColor = UIColor.appColor(.system)
                    // 그외
                    } else {
                        self?.pwSubTitle.alpha = 0
                        self?.pwLine.backgroundColor = UIColor.appColor(.gray210)
                    }
                }
                
            })
            .disposed(by: disposeBag)
        
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
                                    let alert = AlertController(title: "가입되어 있지 않은 메일입니다", message: "회원가입이나 이메일 찾기를 이용해 주세요", preferredStyle: .alert)
                                    alert.setTitleImage(UIImage(named: "alertError"))
                                    let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                    break
                                    
                                default:
                                    print("ErorCode : \(error)")
                                    print("Error: \(error.localizedDescription)")
                                    break
                                }
                            } else {
                                print("loginSucess")
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
    }
    
    @IBAction func pressedRegisterBtn(_ sender: Any) {
        let registerStoryboard = UIStoryboard(name: "Register", bundle: nil)
        // 원본
//        let registerVC = registerStoryboard.instantiateViewController(withIdentifier: "RegisterVC")
        
        // 테스트용으로 바로 학생증 인증 VC로
        let registerVC = registerStoryboard.instantiateViewController(withIdentifier: "RegisterSchoolVC")
        
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
    
    @IBAction func pressedIntroBtn(_ sender: Any) {
        performSegue(withIdentifier: "IntroVC", sender: sender)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FindEmailPWVC" {
            let button: UIButton = sender as! UIButton
            let destinationVC = segue.destination as? FindEmailPWViewController
            destinationVC?.modalPresentationStyle = .fullScreen
            
            switch button.tag {
            // 이메일 찾기
            case 0:
                destinationVC?.viewModel.isActiveEmailView.accept(true)
//                destinationVC?.firstPage.accept(0)
                break
                
            // 비밀번호 찾기
            case 1:
//                destinationVC?.firstPage.accept(1)
                destinationVC?.viewModel.isActiveEmailView.accept(false)
                break
            default:
                break
            }
            
        }
        
        if segue.identifier == "IntroVC" {
            let destinationVC = segue.destination
            destinationVC.modalPresentationStyle = .fullScreen
        }
 
    }
    
    
}

extension LoginViewController {
    func viewDesign() {
        loginBtn.layer.cornerRadius = 16
        registerBtn.layer.cornerRadius = 16
        
        loginTitle.appShadow(.s8)
        
        emailSubTitle.alpha = 0
        pwSubTitle.alpha = 0
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
