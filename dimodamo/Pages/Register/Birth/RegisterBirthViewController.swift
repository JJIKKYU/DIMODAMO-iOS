//
//  RegisterBirthViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/22.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class RegisterBirthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    
    
    private var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBirthDesign()
        
        
        // 4글자가 넘어갈 경우 자동으로 다음 텍스트 필드로 넘어갈 수 있도록
        yearTextField?.addTarget(self, action: #selector(RegisterBirthViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        monthTextField?.addTarget(self, action: #selector(RegisterBirthViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        dayTextField?.addTarget(self, action: #selector(RegisterBirthViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == yearTextField {
            if (textField.text?.count)! >= 4 {
                monthTextField?.becomeFirstResponder()
            }
        }
        else if textField == monthTextField {
            if (textField.text?.count)! >= 2 {
                dayTextField?.becomeFirstResponder()
            }
        }
        else if textField == dayTextField {
            if (textField.text?.count)! >= 2 {
                dayTextField.resignFirstResponder()
            }
        }
    }
    

    @IBAction func pressedNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputGender", sender: sender)
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


extension RegisterBirthViewController {
    
    func registerBirthDesign() {
        designTextfieldTextStyle()
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
    }
    
    func designTextfieldTextStyle() {
        let spacing: CGFloat = 14.0
        
        yearTextField.defaultTextAttributes.updateValue(spacing, forKey: NSAttributedString.Key.kern)
        monthTextField.defaultTextAttributes.updateValue(spacing, forKey: NSAttributedString.Key.kern)
        dayTextField.defaultTextAttributes.updateValue(spacing, forKey: NSAttributedString.Key.kern)
    }
    
    
    func datePickerDesign() {
        // DatePicker 정의
//        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 400))
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.datePickerMode = .date
//        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
//        birthTextField.inputView = datePicker
//        
//        // 상단 툴바 Done 버튼 정의
//        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
//        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
//        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
//        birthTextField.inputAccessoryView = toolBar
    }
    
//    @objc func datePickerDone() {
//        birthTextField.resignFirstResponder()
//    }
//
//    @objc func dateChanged() {
//        birthTextField.text = "\(datePicker.date)"
//    }
}
