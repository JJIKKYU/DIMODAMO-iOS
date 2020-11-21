//
//  LinkPopuVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import STPopup

import RxSwift
import RxCocoa

protocol SendLinkData {
    func sendLinkData(uploadLink: String, uploadLinkData: PreviewResponse)
}

class LinkPopupVC: UIViewController {
    
    let viewModel = LinkPopupViewModel()
    var disposeBag = DisposeBag()
    var sendLinkDataDelegate: SendLinkData?
    
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
    @IBOutlet weak var roundView: UIView! {
        didSet {
//            self.view.backgroundColor = UIColor.clear
            roundView.layer.cornerRadius = 16
            roundView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var loadingView: LottieLoadingView! {
        didSet {
            loadingView.stopAnimation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         상단바 제거
         */
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = UIColor.clear
        
        /*
         뒷 배경 제거
         */
        self.view.backgroundColor = UIColor.clear
        
        /*
         크기 동적 제어
         */
        contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: 307)
        
        /*
         팝업 바깥을 눌렀을 경우에 꺼지도록
         */
        self.popupController?.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap)))
        
        /*
         뷰가 올라오기 전에 미리 키보드 올리기
         */
        self.textField.becomeFirstResponder()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         링크 업로드
         */
        // LinkPopupView에서 주소 및 이미지 체크
        viewModel.uploadLinkDataRelay
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let data = data else {
                    return
                }
                self?.loadingView.stopAnimation()
                
                let imageUrl = URL(string: data.image)
                let title = data.title
                let url = data.url
                
                // 썸네일 이미지가 없다면
                if data.image == "" {
                    self?.thumbImageView.image = UIImage(named: "linkImage")
                }
                // 썸네일 이미지가 있다면
                else {
                    self?.thumbImageView.kf.setImage(with: imageUrl)
                }
                
                self?.titleLabel.text = "\(title)"
                self?.addressLabel.text = "\(url)"
            })
            .disposed(by: disposeBag)
    }
    
    func dataReset() {
        print("데이터를 초기화합니다.")
        titleLabel.text = "내용이 없습니다"
        addressLabel.text = "empty"
        thumbImageView.image = UIImage(named: "linkImage")
        textField.text = nil
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        viewModel.uploadLinkDataRelayReset()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func pressedLinkCheck(_ sender: Any) {
        guard let link = self.textField.text else {
            return
        }
        self.loadingView.playAnimation()
        
        self.viewModel.linkCheck(url: link)
    }
    
    @IBAction func pressedInsertBtn(_ sender: Any) {
        guard let uploadLink = viewModel.uploadLink else {
            return
        }
        
        guard let uploadLinkDataRelayValue = viewModel.uploadLinkDataRelay.value else {
            return
        }
        
        sendLinkDataDelegate?.sendLinkData(uploadLink: uploadLink, uploadLinkData: uploadLinkDataRelayValue)
    }
    
    @objc func backgroundViewDidTap() {
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
