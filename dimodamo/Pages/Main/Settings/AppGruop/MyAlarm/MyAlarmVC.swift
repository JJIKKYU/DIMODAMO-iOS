 //
//  MyAlarmVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MyAlarmVC: UIViewController {
    
    let viewModel = MyAlarmViewModel()
    var disposeBag = DisposeBag()

    // 버튼 색상 체크
    @IBOutlet var switchArr: [UISwitch]! {
        didSet {
            for btn in switchArr {
                btn.onTintColor = UIColor.appColor(.systemActive)
                btn.tintColor = UIColor.appColor(.gray210)
            }
        }
    }
    // 전체 알림 받기
    @IBOutlet weak var allAlarmSwitch: UISwitch!
    // 공지사항
    @IBOutlet weak var noticeSwitch: UISwitch!
    // 인기 컨텐츠 / 추천 컨텐츠
    @IBOutlet weak var hotContentsSwitch: UISwitch!
    // 게시글에서 댓글 달리면 알림
    @IBOutlet weak var commentSwitch: UISwitch!
    // 대댓글 알림
    @IBOutlet weak var commentOfCommentSwitch: UISwitch!
    // 도큐먼트 선정시 알림
    @IBOutlet weak var documentSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 전체 알림 받기 따라서 모두 변경
        allAlarmSwitch.rx.isOn
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                print("전체 설정 버튼 : \(flag)")
                
                
            })
            .disposed(by: disposeBag)
        
        // 로딩이 완료되었을 경우에 반영
        Observable.combineLatest(
            viewModel.noticeRelay,
            viewModel.hotContentsRelay,
            viewModel.commentRelay,
            viewModel.ofCommentRelay,
            viewModel.documentRelay)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] notice, hotCont, comment, ofComment, document in
//                if notice == true && hotCont && comment && ofComment && document {
//                    self?.allAlarmSwitch.setOn(true, animated: true)
//                } else {
//                    self?.allAlarmSwitch.setOn(false, animated: true)
//                }
                
                self?.noticeSwitch.setOn(notice, animated: true)
                self?.hotContentsSwitch.setOn(hotCont, animated: true)
                self?.commentSwitch.setOn(comment, animated: true)
                self?.commentOfCommentSwitch.setOn(ofComment, animated: true)
                self?.documentSwitch.setOn(document, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            noticeSwitch.rx.isOn,
            hotContentsSwitch.rx.isOn,
            commentSwitch.rx.isOn,
            commentOfCommentSwitch.rx.isOn,
            documentSwitch.rx.isOn)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] notice, hotCont, comment, ofComment, document in
                
                // 로딩이 되어 모든 데이터가 세팅이 되었을 경우에
                if self?.viewModel.loadingRelay.value == true {
                    self?.viewModel.setAlarmChange(notice: notice,
                                                   hotContents: hotCont,
                                                   comment: comment,
                                                   ofComment: ofComment,
                                                   document: document)
                    
                    
                }
                
            })
            .disposed(by: disposeBag)
        
        
    }
}
