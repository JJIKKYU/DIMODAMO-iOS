//
//  FindPWViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FindPWViewController: UIViewController {

    @IBOutlet weak var schoolIdTextField: UITextField!
    @IBOutlet weak var schoolIdLine: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLine: UIView!
    
    @IBOutlet weak var findBtn: UIButton!
    
    let viewModel = FindPWViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewDesign()
        
        schoolIdTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.userSchoolIdRelay)
            .disposed(by: disposeBag)
        
        viewModel.userSchoolIdRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                
            })
            .disposed(by: disposeBag)
        
        
        emailTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.userEmailRelay)
            .disposed(by: disposeBag)
        
        viewModel.userEmailRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                print(self?.viewModel.userEmailRelay.value)
            })
            .disposed(by: disposeBag)
        

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    

    @IBAction func pressedFindBtn(_ sender: Any) {
        viewModel.sendPasswordResetMail()
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

extension FindPWViewController {
//    func viewDesign() {
//        findBtn.layer.cornerRadius = 16
//    }
    
}
