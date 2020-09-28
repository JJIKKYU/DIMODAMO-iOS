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

class RegisterSchoolViewController: UIViewController {
    
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var nextTryBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var schoolCardBtn: UIButton!
    
    var viewModel: RegisterViewModel?
    var disposeBag = DisposeBag()
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesisgn()
        imagePickerController.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 다음에 할래요
    @IBAction func pressNextTryBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "주의사항", message: "학교 미인증 상태에서는 서비스 이용이 제한적입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
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
            let alert = UIAlertController(title: "사진을 촬영해주세요", message: "학교 인증 어쩌구", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        dismiss(animated: true, completion: nil)
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
        self.nextTryBtn.layer.cornerRadius = 16
        AppStyleGuide.systemBtnRadius16(btn: finishBtn, isActive: false)
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
    
    
}
