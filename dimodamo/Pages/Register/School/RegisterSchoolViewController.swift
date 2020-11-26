//
//  RegisterSchoolViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import FirebaseStorage
import FirebaseAuth

import McPicker

class RegisterSchoolViewController: UIViewController {
    
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var nextTryBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var schoolCartBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var schoolCardBtn: UIButton! {
        didSet {
            let aspectHeight = (230 / 414) * UIScreen.main.bounds.width
            schoolCartBtnHeightConstraint?.constant = aspectHeight
        }
    }
    
    
    @IBOutlet var schoolDropDownView: UIView!
    @IBOutlet weak var schoolTextField: McTextField!
    @IBOutlet weak var schoolLine: UIView!
    
    @IBOutlet weak var schoolIdTextField: UITextField!
    @IBOutlet weak var schoolIdLine: UIView!
    
    
    var viewModel: RegisterViewModel?
    var disposeBag = DisposeBag()
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesisgn()
        imagePickerController.delegate = self
        self.pickerSchoolTextfieldSetting()
        
        schoolIdTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel!.schoolIdRelay)
            .disposed(by: disposeBag)
        
        self.viewModel?.schoolIdRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] id in
                if id.count == 7 {
                    UIView.animate(withDuration: 0.5) {
                        self?.schoolIdLine.backgroundColor = UIColor.appColor(.gray190)
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self?.schoolIdLine.backgroundColor = UIColor.appColor(.white235)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func pressCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 다음에 할래요
    @IBAction func pressNextTryBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "주의사항", message: "학교 미인증 상태에서는 서비스 이용이 제한적입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.performSegue(withIdentifier: "RegisterFinish", sender: sender)
            self?.viewModel?.schoolCertificationState = .none
            self?.viewModel?.makeStructUserProfile()
            self?.viewModel?.signUp()
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    // 다음으로
    @IBAction func pressFinishBtn(_ sender: Any) {
        viewModel?.makeStructUserProfile()
        viewModel?.signUp()
        if viewModel?.canUploadSchoolCard() == false {
            let alert = UIAlertController(title: "학생증을 촬영해 주세요", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        performSegue(withIdentifier: "RegisterFinish", sender: sender)
//        dismiss(animated: true, completion: nil)
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

extension RegisterSchoolViewController {
    func viewDesisgn() {
//        self.nextTryBtn.layer.cornerRadius = 16
        AppStyleGuide.systemBtnRadius16(btn: finishBtn, isActive: false)
    }
    
    func pickerSchoolTextfieldSetting() {
//        guard let schoolData = self.viewModel?.schoolArrData else {
//            return
//        }
        
        // 임시데이터
        let schoolArrData: [[String]] = [["홍익대학교"]]
        let data: [[String]] = schoolArrData
        let mcInputView = McPicker(data: data)
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        schoolTextField.inputViewMcPicker = mcInputView
        
        schoolTextField.doneHandler = { [weak schoolTextField] (selections) in
            schoolTextField?.text = selections[0]!
            UIView.animate(withDuration: 0.5) {
                self.schoolLine.backgroundColor = UIColor.appColor(.gray190)
            }
        }
        schoolTextField.selectionChangedHandler = { [weak schoolTextField] (selections, componentThatChanged) in
            schoolTextField?.text = selections[componentThatChanged]!
            UIView.animate(withDuration: 0.5) {
                self.schoolLine.backgroundColor = UIColor.appColor(.gray190)
            }
        }
        schoolTextField.cancelHandler = { [weak schoolTextField] in
            schoolTextField?.text = "다니시는 학교를 선택해 주세요."
            UIView.animate(withDuration: 0.5) {
                self.schoolLine.backgroundColor = UIColor.appColor(.white235)
            }
        }
        schoolTextField.textFieldWillBeginEditingHandler = { [weak schoolTextField] (selections) in
            if schoolTextField?.text == "" {
                // Selections always default to the first value per component
                schoolTextField?.text = selections[0]
                UIView.animate(withDuration: 0.5) {
                    self.schoolLine.backgroundColor = UIColor.appColor(.white235)
                }
            }
        }
        
    }
}

//MARK: - 학생증 인증

extension RegisterSchoolViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func pressSchoolCardBtn(_ sender: Any) {
        self.imagePickerController.sourceType = .camera
        
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let imageData = image.resize(withWidth: 400)?.jpeg(.lowest) else { return }
        viewModel?.schoolCardImageData = imageData
        
        // 이미지 저장이 끝났으면 스쿨 이미지 변경 및 버튼 변경
        schoolCardBtn.setImage(UIImage(named: "schoolCardActive"), for: .normal)
        viewModel?.schoolCertificationState = .submit
        UIView.animate(withDuration: 0.5) {
            AppStyleGuide.systemBtnRadius16(btn: self.finishBtn, isActive: true)
            self.progress.setProgress(1, animated: true)
        }
    }
    
    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
        
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }

    
}
