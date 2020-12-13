//
//  SettingMainVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SettingMainVC: UIViewController {
    
    let viewModel = SettingMainViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var settingProfileImageView: UIImageView!
    @IBOutlet weak var settingNicknameLabel: UILabel!
    @IBOutlet weak var settingCreatedAtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         프로필 세팅
         */
        viewModel.mySettingProfile
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let dpti: String = value.dpti,
                    let nickname: String = value.nickname,
                    let createdAt: String = value.registerDate else {
                    return
                }
                self?.settingProfileImageView.image = UIImage(named: "Profile_\(dpti)")
                self?.settingNicknameLabel.text = nickname
                self?.settingCreatedAtLabel.text = createdAt
            })
            .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - 버튼 바인딩
    
    /*
     계정
     */
    @IBAction func pressedBlockedUser(_ sender: Any) {
        performSegue(withIdentifier: "BlockedUserVC", sender: sender)
    }
    
    @IBAction func pressedLogout(_ sender: Any) {
        guard let email: String = viewModel.myEmail else {
            return
        }
        
        // 로그아웃 하겠냐고 Alert 띄움
        let alert = AlertController(title: "정말 로그아웃하시겠습니까?", message: "로그인된 계정 : \(email)", preferredStyle: .alert)
        alert.setTitleImage(UIImage(named: "alertError"))
        let action = UIAlertAction(title: "확인", style: .destructive) { action in
            
            // 로그아웃은 미리 호출
            self.viewModel.logout()
            
            let alert = AlertController(title: "로그아웃 되었습니다", message: "", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertComplete"))
            let action = UIAlertAction(title: "확인", style: .destructive) { action in
                
                // 확인을 누르면 메인으로 이동
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: .main)
                let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginMain")
                
                mainVC.modalPresentationStyle = .fullScreen
                mainVC.modalTransitionStyle = .crossDissolve
                self.present(mainVC, animated: true, completion: nil)
                
            }
            action.setValue(UIColor.appColor(.green2), forKey: "titleTextColor")
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
}
