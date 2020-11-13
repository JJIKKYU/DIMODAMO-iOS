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
    @IBOutlet weak var textField: TextFieldContainerView!
    
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
        self.scrollToBottom(false)
        self.tableViewSetting()
        
        
        /*
         키보드 높이 조절
         */
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    func tableViewSetting() {
        self.tableView.contentInset.top = 116 // 마니또 요청하기 height만큼
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func scrollToBottom(_ isAnimated: Bool){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 9 - 1, section: 0)
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

