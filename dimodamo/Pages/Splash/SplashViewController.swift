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

import FirebaseAuth

class SplashViewController: UIViewController {
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        print("SPlash")
        
        _ = lottie("Splash_1.5C_top", container: topContainer)
        _ = lottie("Splash_1.5C_bottom", container: bottomContainer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
            
            // 로그인 중일 때는 메인으로
            // 로그아웃 상태일 때는 로그인 화면으로
            if user != nil {
                print("현재 로그인중입니다")
                print("현재 로그인 되어 있는 UID : \(Auth.auth().currentUser?.uid)")

                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
