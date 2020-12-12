//
//  BlockedUserVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class BlockedUserVC: UIViewController {
    
    let viewModel = BlockedUserViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableViewSetting()
        
        self.viewModel.blockedUserMapRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.tableView.reloadData()
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

}


// MARK: - TableView

extension BlockedUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableViewSetting() {
        tableView.rowHeight = 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.blockedUserMapRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserCell", for: indexPath) as! BlockedUserCell
        
        let index = indexPath.row
        let model = self.viewModel.blockedUserMapRelay.value
        
        if let nickname = model[index].nickname {
            cell.blockedUserNickname.text = "\(nickname)"
        }
        
        if let type = model[index].type {
            cell.blockedUserProfileImageView.image = UIImage(named: "Profile_\(type)")
            cell.blockedUserNickname.textColor = UIColor.dptiDarkColor("\(type)")
        }
        
        return cell
    }
    
    
}
