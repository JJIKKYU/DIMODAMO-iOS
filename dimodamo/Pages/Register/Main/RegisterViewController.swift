//
//  RegisterViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RegisterViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Clause Screen IBOutlet
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var serviceBtn2: UIButton!
    @IBOutlet weak var marketingBtn: UIView!
    @IBOutlet weak var nextBtnClause: UIButton!
    
    
    // MARK: - All Screen IBOutlet
    // 넥스트 버튼 디자인용 참조
    @IBOutlet weak var nextBtn: UIButton!
    
    // MARK: - Name Screen IBOutlet
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextBtnName: UIButton!
    
    // MARK: - Gender Screen IBOutlet
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    // MARK: - Interest Screen IBOutlet
    @IBOutlet var interestBtnList: Array<UIButton>!

    // MARK: - School Screen IBOutlet
    @IBOutlet weak var nextCertifySchoolBtn: UIButton!
    
    
    // MARK: - View
    
    var disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        self.nameTextField?.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        // test
        nextBtnClause.isEnabled = false
        
        allBtn.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                self?.allBtn.isSelected = self?.allBtn.isSelected == true ? false : true
                
                let allBtnIsSelected: Bool = self?.allBtn.isSelected == true ? true : false
                self?.serviceBtn.isSelected = allBtnIsSelected
                self?.serviceBtn2.isSelected = allBtnIsSelected
            })
            .disposed(by: disposeBag)
        
        
                
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextField?.resignFirstResponder()
    }
    
    
    
    
    
    // MARK: - IBAction
    

    @IBAction func PressedFirstNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputName", sender: sender)
    }
    @IBAction func pressedNameNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputBirthday", sender: sender)
    }
    @IBAction func pressedBirthdayNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputGender", sender: sender)
    }
    @IBAction func preesedGenderNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputInterest", sender: sender)
    }
    @IBAction func pressedInterestNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputNickname", sender: sender)
    }
    @IBAction func pressedNicknameNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputSchool", sender: sender)
    }
    
}

// MARK: -View Design


extension RegisterViewController {
    
    func viewDesign() {
        designNavBar()
        designNextBtn()
        navigationBarDesign()
        designGenderBtn()
        designInterestBtn()
        designSchoolBtn()
    }
    
    func designNavBar() {
        navigationController?.navigationBar.tintColor = UIColor.appColor(.system)
    }
    
    func designNextBtn() {
        nextBtn?.backgroundColor = UIColor.appColor(.systemUnactive)
        nextBtn?.layer.cornerRadius = 16
    }
    
    func navigationBarDesign() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
    }
    
    func designGenderBtn() {
        femaleBtn?.layer.borderWidth = 2
        femaleBtn?.layer.borderColor = UIColor.appColor(.white235).cgColor
        femaleBtn?.layer.cornerRadius = 16
        
        maleBtn?.layer.borderWidth = 2
        maleBtn?.layer.borderColor = UIColor.appColor(.white235).cgColor
        maleBtn?.layer.cornerRadius = 16
    }
    
    func designInterestBtn() {
        interestBtnList?.forEach { button in
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.appColor(.white235).cgColor
        }
    }
    
    func designSchoolBtn() {
        nextCertifySchoolBtn?.layer.cornerRadius = 16
    }
}
