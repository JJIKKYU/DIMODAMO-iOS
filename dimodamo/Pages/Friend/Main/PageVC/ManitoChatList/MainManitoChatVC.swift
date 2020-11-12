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
        return viewModel.manitoChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyManitoCell", for: indexPath) as! MainChatCell
        
        let index = indexPath.row
        let model = viewModel.manitoChatList[index]
        
        cell.chatProfile.image = UIImage(named: "Profile_\(model.type)")
        cell.chatDate.text = "\(model.date)"
        cell.chatNickname.text = "\(model.nickname)"
        cell.chatDescription.text = "\(model.lastChat)"
        cell.chatRemainCount.text = "5"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ManitoChatVC", sender: indexPath.row)
    }
    
    
}
