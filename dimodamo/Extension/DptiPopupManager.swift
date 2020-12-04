//
//  DptiPopupManager.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/05.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import STPopup

// DPTI를 진행하라는 팝업을 관리하는 매니저
class DptiPopupManager {
    
    // 어느 스크린에서 팝업이 뜨는지 체크
    enum popupScreen: Int {
        case home = 0
        case document = 1
        case profile = 2
    }
    
    
    // 팝업을 띄우는 함수
    static func dptiPopup(popupScreen: popupScreen, vc: UIViewController) {
        let storyboard = UIStoryboard(name: "DPTI", bundle: nil)

        let popupVC = storyboard.instantiateViewController(withIdentifier: "DptiBottomPopupVC") as! DptiBottomPopupVC
        
        // 홈에 해당하는 글로 변경
        popupVC.titleValue = popupVC.titleArr[0]
        popupVC.descriptionValue = popupVC.descriptionArr[0]
        
        let popupController = STPopupController(rootViewController: popupVC)
        popupController.style = .bottomSheet
        popupController.present(in: vc.self)
    }
}
