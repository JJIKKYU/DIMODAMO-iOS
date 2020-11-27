//
//  DptiBottomPopupVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/27.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import Lottie

class DptiBottomPopupVC: UIViewController {

    @IBOutlet weak var lottieContainerView: UIView!
    @IBOutlet weak var alreadyDptiBtn: UIButton! {
        didSet {
            alreadyDptiBtn.layer.cornerRadius = 12
            alreadyDptiBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var tryDptiBtn: UIButton! {
        didSet {
            tryDptiBtn.layer.cornerRadius = 12
            tryDptiBtn.layer.masksToBounds = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         상단바 제거
         */
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = UIColor.clear
        
        self.view.layer.cornerRadius = 16
        self.additionalSafeAreaInsets.bottom = 0
        self.popupController?.safeAreaInsets.bottom = 0
        
        /*
         뒷 배경 제거
         */
        self.view.backgroundColor = UIColor.appColor(.white255)
        
        /*
         크기 동적 제어
         */
        contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: 540)
        
        /*
         팝업 바깥을 눌렀을 경우에 꺼지도록
         */
        self.popupController?.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap)))
    }
    
    @objc func backgroundViewDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lottieSetting()
    }
    
    @IBAction func pressedAlreadyDptiBtn(_ sender: Any) {
        
    }
    
    @IBAction func pressedTryDptiBtn(_ sender: Any) {
        
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
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

//MARK: - Lottie

extension DptiBottomPopupVC {
    func lottieSetting() {
        let animationView = Lottie.AnimationView.init(name: "Test_alert")
//        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
//        resultCardView.translatesAutoresizingMaskIntoConstraints = false
        lottieContainerView.addSubview(animationView)
        animationView.topAnchor.constraint(equalTo: lottieContainerView.topAnchor, constant: 0).isActive = true
        animationView.leftAnchor.constraint(equalTo: lottieContainerView.leftAnchor, constant: 0).isActive = true
        animationView.rightAnchor.constraint(equalTo: lottieContainerView.rightAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: lottieContainerView.bottomAnchor, constant: 0).isActive = true
        
        animationView.play()
        animationView.loopMode = .loop
    }
}
