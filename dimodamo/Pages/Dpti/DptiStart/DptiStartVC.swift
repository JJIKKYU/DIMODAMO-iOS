//
//  DptiStartVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/28.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class DptiStartVC: UIViewController {
    
    let viewModel = DptiStartViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var maleBtnWidthConstraint: NSLayoutConstraint! {
        didSet {
            let widthAspect = (150 / 414) * UIScreen.main.bounds.width
            maleBtnWidthConstraint.constant = widthAspect
        }
    }
    @IBOutlet weak var femaleBtnWidthConstraint: NSLayoutConstraint! {
        didSet {
            let widthAspect = (145 / 414) * UIScreen.main.bounds.width
            femaleBtnWidthConstraint.constant = widthAspect
        }
    }
    
    @IBOutlet weak var maleBtnHeightConstraint: NSLayoutConstraint! {
        didSet {
            let heightAspect = (151 / 414) * UIScreen.main.bounds.width
            maleBtnHeightConstraint.constant = heightAspect
        }
    }
    @IBOutlet weak var femaleBtnHeightConstraint: NSLayoutConstraint! {
        didSet {
            let heightAspect = (152 / 414) * UIScreen.main.bounds.width
            femaleBtnHeightConstraint.constant = heightAspect
        }
    }
    
    @IBOutlet weak var maleIconBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton! {
        didSet {
            maleBtn.layer.cornerRadius = 16
            maleBtn.layer.masksToBounds = true
            maleBtn.layer.borderWidth = 2
            maleBtn.layer.borderColor = UIColor.appColor(.gray190).cgColor
        }
    }
    
    @IBOutlet weak var femaleIconBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!{
        didSet{
            femaleBtn.layer.cornerRadius = 16
            femaleBtn.layer.masksToBounds = true
            femaleBtn.layer.borderWidth = 2
            femaleBtn.layer.borderColor = UIColor.appColor(.gray190).cgColor
        }
    }
    @IBOutlet weak var startBtn: UIButton! {
        didSet {
            startBtn.layer.cornerRadius = 16
            startBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var textViewContainer: UIView! {
        didSet {
            textViewContainer.layer.cornerRadius = 16
            textViewContainer.layer.masksToBounds = true
            textViewContainer.appShadow(.s12)
            textViewContainer.backgroundColor = UIColor.appColor(.white255)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.gender
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] gender in
                switch gender {
                case .female:
                    self?.femaleIconBtn.isSelected = true
                    self?.maleIconBtn.isSelected = false
                    self?.genderBtnEnabled(btn: self!.femaleBtn, isSelected: true)
                    self?.genderBtnEnabled(btn: self!.maleBtn, isSelected: false)
                    self?.startBtn.backgroundColor = UIColor.appColor(.system)
                    break
                    
                case .male:
                    self?.femaleIconBtn.isSelected = false
                    self?.maleIconBtn.isSelected = true
                    self?.genderBtnEnabled(btn: self!.femaleBtn, isSelected: false)
                    self?.genderBtnEnabled(btn: self!.maleBtn, isSelected: true)
                    self?.startBtn.backgroundColor = UIColor.appColor(.system)
                    break
                    
                case .none:
                    self?.femaleIconBtn.isSelected = false
                    self?.maleIconBtn.isSelected = false
                    self?.genderBtnEnabled(btn: self!.femaleBtn, isSelected: false)
                    self?.genderBtnEnabled(btn: self!.maleBtn, isSelected: false)
                    self?.startBtn.backgroundColor = UIColor.appColor(.gray210)
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func genderBtnEnabled(btn: UIButton, isSelected: Bool) {
        if isSelected == true {
            btn.layer.borderColor = UIColor.appColor(.system).cgColor
            btn.isSelected = true
        } else {
            btn.layer.borderColor = UIColor.appColor(.gray190).cgColor
            btn.isSelected = false
        }
    }
    
    @IBAction func pressedMaleBtn(_ sender: Any) {
        self.viewModel.gender.accept(.male)
    }
    
    @IBAction func pressedFemalBtn(_ sender: Any) {
        self.viewModel.gender.accept(.female)
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedStartBtn(_ sender: Any) {
        let flag = viewModel.isSelectedGender
        // 성별 선택을 했을 경우
        if flag == true {
            performSegue(withIdentifier: "DptiSurveyVC", sender: nil)
        } else {
            let alert = AlertController(title: "성별을 선택해 주세요", message: "자신의 성별에 맞는 프로필이 생성됩니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DptiSurveyVC" {
            let destinationVC = segue.destination as! DptiSurveyViewController
            destinationVC.viewModel.gender = viewModel.gender.value.description
        }
    }
    

}
