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
    var marketing: Bool
    var nmae: String
    var birth: String
    var Gender: Gender
    var Interest: [Interest]
    var nickName: String
    var school: String
    var schoolCert: Bool
}

// 성별
enum Gender {
    case female
    case male
}

// 관심사 3종 목록
enum Interest {
    case uxui           // UXUI
    case edit           // 편집디자인
    case architecture   // 건축디자인
    case branding       // 브랜딩
    case font           // 폰트
    case exhibit        // 전시무대
    case ad             // 광고
    case crafts         // 공예
    case animation    schoolCertify  // 애니메이션
    case broadcasting   // 방송채널
    case artDirector    // 아트디렉터
    case motion         // 모션
    case industrial     // 산업
    case mediaArt       // 미디어아트
    case interior       // 인테리어
}
