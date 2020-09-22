//
//  RegisterBirthViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/22.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class RegisterBirthViewController: UIViewController {

    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    private var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerDesign()
        AppStyleGuide.systemBtnRadius16(btn: nextBtn, isActive: false)
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
    func datePickerDesign() {
        // DatePicker 정의
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 400))
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        birthTextField.inputView = datePicker
        
        // 상단 툴바 Done 버튼 정의
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        birthTextField.inputAccessoryView = toolBar
    }
    
    @objc func datePickerDone() {
        birthTextField.resignFirstResponder()
    }

    @objc func dateChanged() {
        birthTextField.text = "\(datePicker.date)"
    }
}
