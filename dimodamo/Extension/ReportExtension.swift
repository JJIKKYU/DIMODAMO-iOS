//
//  ReportExtension'.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import UIKit

// 신고 관리
class ReportManager {
    
    static func gotoReportScreen(reportType: ReportType, vc: UIViewController, profileImage: UIImage, nickname: String,
                                 text: String, createAt: String, userUid: String, contentUid: String, targetBoard: TargetBoard) {
        let storyboard = UIStoryboard(name: "Report", bundle: nil)

        let reportVC = storyboard.instantiateViewController(withIdentifier: "ReportMain") as! ReportMainVC
        
        // 신고 타입을 넘겨서 세팅 먼저 진행
        reportVC.topViewSetting(reportType: reportType,
                                profileImage: profileImage,
                                nickname: nickname,
                                text: text,
                                createAt: createAt,
                                userUid: userUid,
                                contentUid: contentUid,
                                targetBoard: targetBoard)
        vc.navigationController?.pushViewController(reportVC, animated: true)

    }
}
