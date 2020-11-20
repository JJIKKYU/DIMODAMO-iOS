//
//  LinkPopuVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import BottomPopup

import RxSwift
import RxCocoa

class LinkPopupVC: BottomPopupViewController {
    
    let viewModel = LinkPopupViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1.5
            containerView.layer.borderColor = UIColor.appColor(.white235).cgColor
            containerView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView! {
        didSet {
            thumbImageView.layer.cornerRadius = 4
            thumbImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var insertBtn: UIButton! {
        didSet {
            insertBtn.layer.cornerRadius = 12
            insertBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 4
            textField.layer.masksToBounds = true
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.appColor(.gray210).cgColor
        }
    }
    
    
    let height: CGFloat = 307
    var topCornerRadius: CGFloat = 16
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
   
    
    override var popupHeight: CGFloat { return height }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius }
    
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var popupDimmingViewAlpha: CGFloat { return 0.6 }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Keyboard
         */
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func dataReset() {
        print("데이터를 초기화합니다.")
        titleLabel.text = "내용이 없습니다"
        addressLabel.text = "empty"
        thumbImageView.image = UIImage(named: "linkImage")
        textField.text = nil
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Keyboard

extension LinkPopupVC: UITextFieldDelegate {
    // 키보드 업, 다운 관련
    @objc func moveUpTextView(_ notification: NSNotification) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let bottomSafeArea = window?.safeAreaInsets.bottom else {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    @objc func moveDownTextView() {
        self.view.transform = .identity
    }
}
