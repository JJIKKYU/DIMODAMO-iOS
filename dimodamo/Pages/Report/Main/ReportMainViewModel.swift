//
//  ReportMainViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

import RxSwift
import RxRelay

class ReportMainViewModel {
    
    private let db = Firestore.firestore()
    
    // 신고 가능한 항복
    let reportArr: [String] = [
        "부적절한 게시물",
        "부적절한 태그",
        "게시글 / 댓글 도배",
        "욕설",
        "특정 인물 비하 / 비방",
        "음란물",
        "불건전한 대화 / 만남 유도",
        "홍보성 컨텐츠",
        "상업적 광고 및 판매",
        "기타"
    ]
    
    // 유저가 선택한 신고 항목
    var selectedReportValue: String?
    var isSelectedReportValue: Bool {
        if selectedReportValue == nil { return false }
        return true
    }
    
    var currentReportBoard: TargetBoard?
    
    // 현재 스크린에서 진행 중인 신고 타입
    // 게시글, 댓글, 유저
    var currentReportType: ReportType?
    
    // 신고하는 유저 UID
    var myUID: String {
        return Auth.auth().currentUser!.uid
    }
    
    // 신고할 콘텐츠 UID
    var contentUID: String?
    
    // 신고 당하는 유저
    var targetUserUID: String?
    
    // 신고 내용
    var reportText: String?
    var isWriteReportText: Bool {
        if self.reportText?.count == 0 || self.reportText == "내용을 입력해 주세요" { return false}
        return true
    }
    
    // 신고 성공 유무
    let reportState = BehaviorRelay<reportState>(value: .idle)
    enum reportState: Int {
        case idle
        case complete
        case fail
    }
    
    // 이미 신고를 진행했는지 미리 변수로 가지고 있음
    var alreadyPrevReport: Bool = false
    
    // 이미 신고를 진행했는지 체크
    func prevReportCheck() {
        let userUid: String = Auth.auth().currentUser!.uid
        
        db.collection("users").document("\(userUid)")
            .getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    if let reportList: [String: Bool] = data!["report_list"] as? [String: Bool] {
                        print("\(reportList)")
                        
                        let contentUID: String = self?.contentUID ?? ""
                        let targetUserUID: String = self?.targetUserUID ?? ""
                        let reportType: ReportType = self?.currentReportType ?? .comment
                        print("reportType \(reportType), targetuserUID: \(targetUserUID)")
                    
                        let reportData: Bool = reportList["\(contentUID)"] ?? false
                        let reportUserData: Bool = reportList["\(targetUserUID)"] ?? false
                        
                        // 신고 타입이 댓글이거나, 게시글일 경우에는 콘텐츠UID로 중복검사
                        if reportType == .comment || reportType == .post {
                            self?.alreadyPrevReport = reportData
                            print("중복검사 진행")
                        }
                        // 신고 타입이 유저일 경우, 유저 UID로 중복검사
                        else if reportType == .user {
                            self?.alreadyPrevReport = reportUserData
                            print("중복검사 진행")
                        }
                        
                        
                    }
                    
                } else {
                    print("Documnet does not exist")
                }
            }
    }
    
    // 신고 로직
    func report() {
        let report = Report()
        
        // DocumentID를 미리 불러오기 위해
        let document = db.collection("report/").document()
        let id: String = document.documentID
        
        // 신고한 날짜 및 시간
        let unixTimestamp = NSDate().timeIntervalSince1970
        
        let contentUID: String = self.contentUID ?? "없음"
        
        guard let targetUserUID: String = targetUserUID,
              let reportType: ReportType = currentReportType,
              let reportText: String = reportText,
              let selectedReportValue: String = selectedReportValue,
              let targetBoard: TargetBoard = currentReportBoard else {
            return
        }
        
        report.reportId = "\(id)"
        report.targetType = reportType.rawValue
        report.targetId = "\(contentUID)" // 신고 당한 게시글
        report.targetUserId = "\(targetUserUID)" // 신고 당하는 사람의 UID
        report.userId = "\(myUID)" // 신고한 사람 (본인)
        report.reportDesc = "\(reportText)"
        report.timestamp = unixTimestamp
        report.reportKind = "\(selectedReportValue)"
        report.targetBoard = "\(targetBoard.rawValue)"
        
        print(report.dictionary)
        
        document.setData(report.dictionary) { err in
            if let err = err {
                print("신고하는 도중 오류가 발생했습니다 : \(err.localizedDescription)")
                self.reportState.accept(.fail)
            } else {
                print("신고가 완료되었습니다 : \(id)")
                self.addUserReportList(contentUID: contentUID, reportType: reportType, targetUserUID: targetUserUID)
                self.reportState.accept(.complete)
            }
        }
    }
    
    // 신고할 때, 신고한 UID 입력
    func addUserReportList(contentUID: String, reportType: ReportType, targetUserUID: String) {
        
        var reportTargetUID: String?
        
        // 포스트와 코멘트는 신고할 때 신고 게시글 및 코멘트 (contentUID)를 신고 목록에 추가
        if reportType == .comment || reportType == .post {
            reportTargetUID = contentUID
        }
        // 신고 대상이 유저일 경우에는 유저 UID를 추가
        else {
            reportTargetUID = targetUserUID
        }
        
        guard let reportUID: String = reportTargetUID else {
            return
        }
        
        // 신고할 때 신고 리스트에 추가
        db.collection("users").document("\(self.myUID)")
            .setData(
                ["report_list" : ["\(reportUID)" : true]],
                merge: true
            )
    }
    
    init() {
        self.prevReportCheck()
    }
    
    
}
