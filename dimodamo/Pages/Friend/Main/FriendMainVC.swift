//
//  FriendMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FriendMainVC: UIViewController {
    
    var disposeBag = DisposeBag()
    @IBOutlet weak var manitoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manitoTableView.delegate = self
        manitoTableView.dataSource = self
        manitoTableViewSetting()
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


extension FriendMainVC: UITableViewDelegate, UITableViewDataSource {
    func manitoTableViewSetting() {
        manitoTableView.rowHeight = 98
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyManitoCell", for: indexPath)
        
        return cell
    }
    
    
}
