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
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UIView! {
        didSet {
            textField.layer.cornerRadius = 24
            textField.clipsToBounds = true
            textField.layer.masksToBounds = false
            textField.appShadow(.s20)
        }
    }
    
    @IBOutlet weak var manitoBtn: UIButton! {
        didSet {
            manitoBtn.layer.cornerRadius = manitoBtn.frame.height / 2
            manitoBtn.layer.borderWidth = 1.5
            
            // 상대방 쪽지 컬러로 변경할 것
            let userType = viewModel.yourUserType.value
            manitoBtn.layer.borderColor = UIColor.dptiDarkColor(userType).cgColor
            manitoBtn.setTitleColor(UIColor.dptiDarkColor(userType), for: .normal)
        }
    }
    
    var manitoChat: [Chat] = [
        Chat(kind: 0, text: "안녕하세요! 아트보드 글 보고 쪽지 남깁니다!"),
        Chat(kind: 0, text: "혹시 마니또 요청 받아주실수 있으신지요ㅠㅠㅠㅜ가능할까요?"),
        Chat(kind: 1, text: "안녕하세요~! 반갑습니다! 마니또 요청 받아드릴게요! 잠시만요~!"),
    ]
    
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
        
        /*
         키보드 높이 조절
         */
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        let userType = viewModel.yourUserType.value
        navigationController?.navigationBar.barTintColor = UIColor.dptiDarkColor(userType)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appColor(.textBig)]
        
        /*
         키보드 높이 조절 옵저버 해제
         */
        NotificationCenter.default.removeObserver(self)
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
        self.scrollToBottom(false)
        self.tableViewSetting()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func pressedManitoApplyBtn(_ sender: Any) {
        
    }
    
}

//MARK: - TableView

extension MessageVC: UITableViewDelegate, UITableViewDataSource, TableReloadProtocol {
    func tableReload() {
        self.tableView.reloadData()
        print("reload합니다")
    }
    
    func tableViewSetting() {
        self.tableView.contentInset.top = 116 // 마니또 요청하기 height만큼
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 상대방 유저 타입
        let yourType = self.viewModel.yourUserType.value
        let index: Int = indexPath.row
        
        let key = manitoChat[index].text
        let value = manitoChat[index].kind
        
        print("\(key) + \(value) == \(index)")
        
        switch value {
        case 0:
            let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourChat", for: indexPath) as! YourChatCell
            
            yourCell.profile.image = UIImage(named: "Profile_\(yourType)")
            yourCell.messageBox.layer.borderColor = UIColor.dptiDarkColor(yourType).cgColor
            yourCell.chagneColorGoodSign(yourType: "\(yourType)")
            yourCell.delegate = self
            yourCell.messageBox.text = "\(key)"
            yourCell.delegate = self
            
            return yourCell
            
        case 1:
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MyChat", for: indexPath) as! MyChatCell
            myCell.messageBox.text = "\(key)"
            
            return myCell
            
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func scrollToBottom(_ isAnimated: Bool){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 3 - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
        }
    }
}



//MARK: - 키보드 높이 조절

extension MessageVC {
    @objc func moveUpTextView(_ notification: NSNotification) {
        let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        guard let bottomSafeArea = window?.safeAreaInsets.bottom else {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.textField?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea)
            self.tableView.contentInset.bottom = keyboardSize.height
            self.scrollToBottom(true)
            //                        self.commentTableViewBottom.constant = self.commentTableViewBottom.constant + keyboardSize.height
            //            self.scrollView?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea!)
        }
    }
    
    @objc func moveDownTextView() {
        self.textField?.transform = .identity
        self.tableView.contentInset.bottom = 0
        //        self.scrollView?.transform = .identity
        //                self.commentTableViewBottom.constant = 0
    }
}
