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
    }
}
