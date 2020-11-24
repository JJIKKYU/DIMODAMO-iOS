//
//  MainManitoChatVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay

class MainManitoChatVC: UIViewController {
    
    let viewModel = MainManitoChatViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableViewSetting()
        
        
        Observable.combineLatest(
            self.viewModel.chatListRelay,
            self.viewModel.userDataArr
        ).observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] chatList, userData in
            if chatList.count == userData.count && userData.count != 0 {
                self?.tableView.reloadData()
            }
        })
        .disposed(by: disposeBag)
        
//        self.viewModel.chatListRelay
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] _ in
//                self?.tableView.reloadData()
//                print("리로드합니다.")
//            })
//            .disposed(by: disposeBag)
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

extension MainManitoChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableViewSetting() {
        tableView.rowHeight = 98
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.chatListRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyManitoCell", for: indexPath) as! MainChatCell
        
        let index = indexPath.row
        let model = viewModel.chatListRelay.value[index]
        
        cell.chatDate.text = "\(model.timestamp)"
        
        let nickname = self.viewModel.getUserNickname(userUid: model.target_user_uid)
        cell.chatNickname.text = "\(nickname)"
        
        let type = self.viewModel.getUserDpti(userUid: model.target_user_uid)
        cell.chatNickname.textColor = UIColor.dptiDarkColor(type)
        cell.chatProfile.image = UIImage(named: "Profile_\(type)")
        
        cell.chatDescription.text = "\(model.last_message)"
        cell.chatRemainCount.text = "\(model.unread_message_count)"
        
        return cell
    }
    
    /*
     테이블 셀을 눌렀을 경우
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Friends", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ManitoChatVC") as! ManitoChatVC
        
        /*
         상대방 UID 및 type 세팅
         */
        let index = indexPath.row
        vc.viewModel.yourType.accept(viewModel.manitoChatList[index].type)
        vc.viewModel.yourUID.accept(viewModel.manitoChatList[index].uid)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
