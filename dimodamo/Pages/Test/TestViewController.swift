//
//  TestViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/20.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let communityStoryboard: UIStoryboard = UIStoryboard(name: "Community", bundle: .main)
    let registerStoryboard: UIStoryboard = UIStoryboard(name: "Register", bundle: .main)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressDptiMain(_ sender: Any) {
        performSegue(withIdentifier: "DptiMain", sender: sender)
    }
    
    @IBAction func pressCommunityMain(_ sender: Any) {
        print(communityStoryboard)
        let communityVC: UIViewController = communityStoryboard.instantiateViewController(identifier: "CommunityMain")
        print(communityVC)
        
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//
//        transition.subtype = CATransitionSubtype.fromRight
//        view.window!.layer.add(transition, forKey: kCATransition)
        communityVC.modalPresentationStyle = .fullScreen
        present(communityVC, animated: true, completion: nil)

//        communityVC.m
//        self.present(communityVC, animated: true, completion: nil)
    }

    @IBAction func pressRegister(_ sender: Any) {
        let registerVC: UIViewController = registerStoryboard.instantiateViewController(withIdentifier: "RegisterMain")
        print("\(registerStoryboard), \(registerVC)")
        
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: registerVC)

        navBarOnModal.modalPresentationStyle = .fullScreen
        present(navBarOnModal, animated: true, completion: nil)
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
