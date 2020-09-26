//
//  RegisterInterestViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RegisterInterestViewController: UIViewController {

    @IBOutlet var interestBtnList: Array<UIButton>!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    var viewModel: RegisterViewModel?
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        viewModel?.interestList.accept([])
        
        interestBtnList.enumerated().forEach { index, interestBtn in
            interestBtn.rx.tap
                .subscribe(onNext: { [weak self] in
//                    print("\(interestBtn.tag)")
                    let tag: Int = Int(interestBtn.tag)
                    
                    var interestList = (self?.viewModel?.interestList.value)!
                    
                    // 선택한 버튼이 이미 선택된 상태라면
                    if interestBtn.isSelected {
                        var selectedBtnIndex: Int?
                        self?.viewModel?.interestList.value.enumerated().forEach { index, selectedInterest in
                            
                            // 해당 버튼의 밸류와 이미 선택한 밸류 리스트에서 인덱스 서치
                            if selectedInterest.rawValue == interestBtn.tag {
                                selectedBtnIndex = index
                            }
                        }
                        // 인덱스에 해당하는 아이템을 리스트에서 삭제
                        interestList.remove(at: selectedBtnIndex!)
                        // 삭제 후에 다시 저장
                        self?.viewModel?.interestList.accept(interestList)
                        
                        interestBtn.isSelected = false
                        self?.selectedBtn(button: interestBtn, isSelected: interestBtn.isSelected)
                        
                    } else if !(interestBtn.isSelected) && (self?.viewModel?.interestList.value.count)! < 3 {
                        // 선택한 개수가 3개 이하일 경우에는 리스트에 추가
                        self?.viewModel?.interestList.accept(interestList + [Interest(rawValue: tag)!])
                    
                        interestBtn.isSelected = true
                        self?.selectedBtn(button: interestBtn, isSelected: interestBtn.isSelected)
                    }
                    
                    
                    
                    })
                .disposed(by: disposeBag)
        }
        
        viewModel?.interestList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] _ in
                self?.countLabel.text = "\(String((self?.viewModel?.interestList.value.count)!))/3"
                if (self?.viewModel?.interestList.value.count)! == 3 {
                    UIView.animate(withDuration: 0.5) {
                        self?.progress.setProgress(0.7, animated: true)
                        AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: true)
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self?.progress.setProgress(0.56, animated: true)
                        AppStyleGuide.systemBtnRadius16(btn: self!.nextBtn, isActive: false)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputNickname" {
            let destinationVC = segue.destination as? RegisterNicknameViewController
            destinationVC?.viewModel = self.viewModel
        }
    }
    
    @IBAction func pressedInterestNextBtn(_ sender: Any) {
        performSegue(withIdentifier: "InputNickname", sender: sender)
    }

}


extension RegisterInterestViewController {
    func viewDesign() {
        designInterestBtn()
        designNextBtn()
    }
    
    func designInterestBtn() {
        interestBtnList?.forEach { button in
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.appColor(.white235).cgColor
        }
    }
    
    func designNextBtn() {
        nextBtn?.backgroundColor = UIColor.appColor(.gray210)
        nextBtn?.layer.cornerRadius = 16
    }
    
    func selectedBtn(button: UIButton, isSelected: Bool) {
        button.layer.borderColor = isSelected == true ? UIColor.appColor(.gray190).cgColor : UIColor.appColor(.white235).cgColor
        button.isSelected = isSelected
    }
}
