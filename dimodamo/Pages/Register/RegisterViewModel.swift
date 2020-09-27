//
//  RegisterViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/22.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import FirebaseAuth
import FirebaseStorage
import Firebase

class RegisterViewModel {
    
    // RegisterClause
    // 약관 동의
    var serviceBtnRelay = BehaviorRelay(value: false) // true일 경우 동의
    var serviceBtn2Relay = BehaviorRelay(value: false) // true일 경우 동의
    var markettingBtnRelay = BehaviorRelay(value: false) // true일 경우 동의
    
    // RegisterName
    // 이름 작성
    var userEmail: String = ""
    var userEmailRelay = BehaviorRelay(value: "")
    //    var isVailed: Bool { userEmailRelay.value.count >= 2 } // 이메일 정규식 확인
    
    // RegisterBirth
    // 생년월일
    var birth = BehaviorRelay(value: "")
    var month = BehaviorRelay(value: "")
    var day = BehaviorRelay(value: "")
    lazy var birthMonthDay: String = "\(birth.value)_\(month.value)_\(day.value)"
    
    // RegisterPW
    var userFirstPWRelay = BehaviorRelay(value: "")
    var userSecondPWRelay = BehaviorRelay(value: "")
    var userPW: String = ""
    
    // RegisterGender
    // 성별
    var gender: Gender? = nil
    
    // RegisterInterest
    // 관심사
    var interestList: BehaviorRelay<[Interest]> = BehaviorRelay(value: [])
    
    // RegisterNickname
    // 닉네임 입력
    var nickName: String = ""
    var nickNameRelay = BehaviorRelay(value: "")
    var isVailedNickName: Bool { nickNameRelay.value.count >= 4 && nickNameRelay.value.count <= 8 }
    
    // RegisterSchool
    // 학교 인증
    var schoolCardImageData: Data?
    var schoolCertificationState: CertificationState = .none
    
    
    // 최종 유저 프로필
    var userProfile: Register = Register()
    private let storage = Storage.storage().reference()
    private var ref: DatabaseReference!
    
    
    init() {
        
    }
    
    func isValiedBirth() -> Bool {
        var birthValied: Bool = false
        if birth.value.count >= 4 && Int(birth.value)! < 2020 {
            birthValied = true
        } else { birthValied = false }
        
        var monthValied: Bool = false
        if month.value.count >= 2 && Int(month.value)! <= 12 {
            monthValied = true
        } else { monthValied = false }
        
        var dayValied: Bool = false
        if month.value.count >= 2 && Int(day.value)! <= 31 {
            dayValied = true
        } else { dayValied = false }
        
        if birthValied && monthValied && dayValied {
            return true
        } else { return false }
    }
    
    // 이메일 정규식
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.userEmail)
    }
    
    // 리얼타임 데이터베이스에서 리스트 형식으로 가져와서 중복 체크 하는 방법으로 해야할듯?
    func firebaseEmailCheck() {
        
    }
    
    // 회원가입
    func signUp() {
        Auth.auth().createUser(withEmail: self.userEmail,
                               password: self.userFirstPWRelay.value,
                               completion: {  (user, error) in
                                
                                guard error == nil else { return }
                                guard let user = user else { return }
                                
                                print("회원가입 성공")
                                print(user.user.uid)
                                self.ref = Database.database().reference()
                                
                                print((self.userProfile.getDict()))
                                let userDataArraay: [String : Any] = self.userProfile.getDict()
//                                self.ref.child("users/\(user.user.uid)").setValue(userDataArraay)
                                
                                APIService.fireStore.collection("users").document("\(user.user.uid)").setData(userDataArraay) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Document added")
                                    }
                                }
                                
                               })
    }
    
    // 모든 정보들을 구조체 내에 넣는 작업
    func makeStructUserProfile() {
        self.userProfile.marketing = markettingBtnRelay.value  // 마케팅 유무
        self.userProfile.id = userEmailRelay.value        // 유저 아이디
        self.userProfile.Gender = gender!
        self.userProfile.Interest = interestList.value
        self.userProfile.nickName = nickNameRelay.value
        self.userProfile.school = "홍익대학교"
        self.userProfile.schoolCertState = self.schoolCertificationState
    }
    
    func uploadSchoolCard() -> Bool{
        if schoolCardImageData == nil {
            
            return false
        }
        
        storage.child("certification/\(String(describing: userEmail)).png")
            .putData(schoolCardImageData!
                     , metadata: nil
                     , completion: { _, error in
                        guard error == nil else {
                            print("Failed to upload")
                            return
                        }
                        
                        self.storage.child("images/file.png").downloadURL(completion: { url, error in
                            guard let url = url, error == nil else {
                                return
                            }
                            
                            let urlString = url.absoluteString
                            print("DownloadURL : \(urlString)")
                            UserDefaults.standard.set(urlString, forKey: "url")
                        })
                     })
        
        return true
    }
    
    // 패스워드
    func isValidPassword(pw: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,20}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: pw)
    }
}

