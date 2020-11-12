//
//  MessageVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MessageVC: UIViewController {
    
    let viewModel = MessageViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var manitoBtn: UIButton! {
        didSet {
            manitoBtn.layer.cornerRadius = manitoBtn.frame.height / 2
            manitoBtn.layer.borderWidth = 1.5
            
            // 상대방 쪽지 컬러로 변경할 것
            let userType = viewModel.userType.value
            manitoBtn.layer.borderColor = UIColor.dptiDarkColor(userType).cgColor
            manitoBtn.setTitleColor(UIColor.dptiDarkColor(userType), for: .normal)
        }
    }
    
    /*
     ViewLoad
     */
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animate()
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
        }, completion: nil)
    }
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.white255)
        
        // 해당 유저 컬러로 변경할 것
        let userType = viewModel.userType.value
        navigationController?.navigationBar.barTintColor = UIColor.dptiDarkColor(userType)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appColor(.textBig)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
        self.scrollToBottom()
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


extension MessageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourChat", for: indexPath) as! YoutChatCell
            
            let userType = self.viewModel.userType.value
            yourCell.messageBox.layer.borderColor = UIColor.dptiDarkColor(userType).cgColor
            yourCell.profile.image = UIImage(named: "Profile_\(userType)")
            return yourCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MyChat", for: indexPath)
            return myCell
        }
        
        
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 12 - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
