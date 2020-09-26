//
//  RegisterNameViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/22.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RegisterNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var progress: UIProgressView!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var checkIcon: UIImageView!
     
    var viewModel : RegisterViewModel? = nil
    var disposeBag = DisposeBag()
    
    // 스크린이 로드 되기 전에 키보드 미리 올려놓기
    override func viewWillAppear(_ animated: Bool) {
        self.nameTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { _ in
                print("editing state changed")
            })
            .disposed(by: disposeBag)
     
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputBirthday" {
            let destinationVC = segue.destination as? RegisterBirthViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextField.resignFirstResponder()
    }
    
    
    // 키보드 업, 다운 관련
    @objc func moveUpTextView(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0, animations: {
                            self.nextBtn?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            })
        }
    }
    
    @objc func moveDownTextView() {
        self.nextBtn?.transform = .identity
    }
    

    // MARK: - Navigation
    
    @IBAction func pressedNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputBirthday", sender: sender)
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
    


extension RegisterNameViewController {
    
}
