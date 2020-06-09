//
//  ChatViewController.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/06/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        navigationItem.title = Constants.appName
        navigationItem.hidesBackButton = true
        
        // xib파일 연결
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        // 데이터 읽기
        loadMessages()
        
    }
    
    func loadMessages() {
        
        // .order와 listener 주의해서 보기
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dataField)
            .addSnapshotListener { (querySnapShot, error) in
            
            self.messages = []
            
            if let e = error {
                print("There was an issue retriebing data from Firestore. \(e)")
            } else {
                 
                if let snapshotDocuments = querySnapShot?.documents {
                    // 각각 데이터 출력
                    for doc in snapshotDocuments {
                        // print(doc.data())
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String,
                           let messageBody = data[Constants.FStore.bodyField] as? String {
                           let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                // 메세지 보내면 스크롤
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        // 옵셔널 String이기 때문에
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data:
                [Constants.FStore.senderField: messageSender,
                 Constants.FStore.bodyField: messageBody,
                 Constants.FStore.dataField: Date().timeIntervalSince1970
            ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        self.messageTextfield.text = ""
                        print("Successfully saved data.")
                    }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }

}

// 데이터 소스를 담당하는 프로토콜
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
            as! MessageCell
        cell.label.text = message.body
        
        // This is a message from the current user.
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        }
        // This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        return cell
    }
}

