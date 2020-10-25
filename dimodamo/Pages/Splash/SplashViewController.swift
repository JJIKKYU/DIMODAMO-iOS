//
//  SplashViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import Lottie

import RxSwift
import RxCocoa

import Firebase

class SplashViewController: UIViewController {
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        _ = lottie("Splash_1.5C_top", container: topContainer)
        _ = lottie("Splash_1.5C_bottom", container: bottomContainer)
        
        // 메인 페이지를 로딩하는 경우가 많으므로, 로그인할 때 메모리 손실을 감수 하더라도 Main을 먼저 로드해서,
        // 로딩 시간에 최대한 로드를 미리 해놓을 수 있도록
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
            
            // 로그인 중일 때는 메인으로
            // 로그아웃 상태일 때는 로그인 화면으로
            if user != nil {
                print("현재 로그인중입니다")
                print("현재 로그인 되어 있는 UID : \(Auth.auth().currentUser?.uid)")
                self.getUserData()

                mainVC.modalPresentationStyle = .fullScreen
                mainVC.modalTransitionStyle = .crossDissolve
                self.present(mainVC, animated: true, completion: nil)

            } else {
                print("로그아웃 상태입니다")
                let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: .main)
                let loginVC: UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "IntroVC")
                
                loginVC.modalPresentationStyle = .fullScreen
                loginVC.modalTransitionStyle = .crossDissolve
                self.present(loginVC, animated: true, completion: nil)

            }
        }
        
    }
    
    func lottie(_ path: String, container: UIView) -> AnimationView {
        let animationView = Lottie.AnimationView.init(name: "\(path)")
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animationView)
        if container == topContainer {
            animationView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        } else {
            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }

        animationView.play()
        
        return animationView
    }
    
    func getUserData() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document("\(userUID)").getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()
                
                guard let userNickname: String = data!["nickName"] as? String else {
                    return
                }
                
                guard let userDpti: String = data!["dpti"] as? String else {
                    return
                }
                
                let userDefaults = UserDefaults.standard
                
                /*
                 유저 닉네임 설정
                 */
                var userDefaultsUserNickname = userDefaults.string(forKey: "nickname") ?? ""
                
                if userNickname != userDefaultsUserNickname {
                    userDefaults.setValue("\(userNickname)", forKey: "nickname")
                    userDefaultsUserNickname = userDefaults.string(forKey: "nickname") ?? ""
                }
                
                var userDefaultsUserDpti = userDefaults.string(forKey: "dpti") ?? ""
                
                if userDpti != userDefaultsUserDpti {
                    userDefaults.setValue("\(userDpti)", forKey: "dpti")
                    userDefaultsUserDpti = userDefaults.string(forKey: "dpti") ?? ""
                }
                print("유저의 닉네임은 \(userDefaultsUserNickname)이며, 유저의 타입은 \(userDefaultsUserDpti) 입니다.")
                
            } else {
                print("유저 데이터에 있는 타입과 닉네임이 유저디폴트로 입력되지 못했습니다.")
            }
        }
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
