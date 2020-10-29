//
//  Register.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

// 가입 프로세스에 포함되는 정보
// 추가된다면 DPTI 추가 될듯
struct Register {
    var marketing: Bool = false
    var id: String = ""
    var Gender: Gender = .male
    var Interest: [Interest] = []
    var nickName: String = ""
    var school: String = ""
    var schoolCertState: CertificationState = .none
    var dpti: String = ""
    var heartComments: [String] = []
    
    func getDict() -> [String:Any] {
        let dict: [String:Any] = [
            "marketing": self.marketing == true ? "true" : "false",
            "id": self.id,
            "gender": self.Gender.description,
            "interest": [
                self.Interest[0].description,
                self.Interest[1].description,
                self.Interest[2].description,
            ],
            "nickName": self.nickName,
            "school" : self.school,
            "schoolCert" : self.schoolCertState.description,
            "rejectionReason" : "",
            "dpti" : "",
            "heartComments": heartComments
        ]
        
        return dict
    }
}

enum MailCheck {
    case none
    case possible
    case impossible
}

enum PWCheck {
    case nothing                // 아무것도 입력하지 않았을 경우
    case onlyFirstTextfield     // 첫 번째 텍스트 필드만 입력 한 경우
    case possible               // 패스워드 사용이 가능한 경우
}

enum NicknameCheck {
    case nothing
    case possible
    case impossible
}

// 성별
enum Gender {
    case female
    case male
    
    var description: String {
        switch self {
        case .female:
            return "female"
        case .male:
            return "male"
        }
    }
}

// 학교 인증 진행 정도
enum CertificationState {
    case none       // 제출하지 않음
    case submit     // 제출
    case rejection  // 거절
    case approval   // 승인
    
    var description: String {
        switch self {
        case .none:
            return "none"
        case .submit:
            return "submit"
        case .rejection:
            return "rejection"
        case .approval:
            return "approval"
        }
    }
}

// 관심사 3종 목록
enum Interest: Int {
    case uxui           // UXUI
    case edit           // 편집디자인
    case architecture   // 건축디자인
    case branding       // 브랜딩
    case font           // 폰트
    case exhibit        // 전시무대
    case ad             // 광고
    case crafts         // 공예
    case animation      // 애니메이션
    case broadcasting   // 방송채널
    case artDirector    // 아트디렉터
    case motion         // 모션
    case industrial     // 산업
    case mediaArt       // 미디어아트
    case interior       // 인테리어
    
    var description: String {
        switch self {
        case .ad:
            return "ad"
        case .uxui:
            return "uxui"
        case .edit:
            return "edit"
        case .architecture:
            return "architecture"
        case .branding:
            return "branding"
        case .font:
            return "font"
        case .exhibit:
            return "exhibit"
        case .crafts:
            return "crafts"
        case .animation:
            return "animation"
        case .broadcasting:
            return "broadcasting"
        case .artDirector:
            return "artDirector"
        case .motion:
            return "motion"
        case .industrial:
            return "industrial"
        case .mediaArt:
            return "mediaArt"
        case .interior:
            return "interior"
        }
    }
}
