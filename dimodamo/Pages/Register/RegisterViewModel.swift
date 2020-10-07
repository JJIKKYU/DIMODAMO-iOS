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
    
    // RegisterID
    // 이메일 작성
    var prevUserEmail: String = "" // 이전에 작성했던 이메일과 대조하기 위해서
    var userEmailRelay = BehaviorRelay(value: "")
    var isVailedUserEmail = BehaviorRelay<MailCheck>(value: .none)
    
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
    
    
    // 이메일 정규식
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.userEmailRelay.value)
    }
    
    // 회원가입
    func signUp() {
        
        var userUID: String = ""
        Auth.auth().createUser(withEmail: self.userEmailRelay.value,
                               password: self.userFirstPWRelay.value,
                               completion: {  (user, error) in
                                
                                guard error == nil else { return }
                                guard let user = user else { return }
                                
                                print("회원가입 성공")
                                userUID = user.user.uid
                                self.ref = Database.database().reference()
                                
                                print((self.userProfile.getDict()))
                                let userDataArraay: [String : Any] = self.userProfile.getDict()
                                //                                self.ref.child("users/\(user.user.uid)").setValue(userDataArraay)
                                
                                APIService.fireStore.collection("users").document("\(userUID)").setData(userDataArraay) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Document added")
                                        if self.canUploadSchoolCard() == true {
                                            self.uploadSchoolCard(userUID: userUID)
                                        }
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
    
    func canUploadSchoolCard() -> Bool{
        if schoolCardImageData == nil {    
            return false
        }
        return true
    }
    
    func uploadSchoolCard(userUID: String) {
        storage.child("certification/\(userUID).png")
            .putData(schoolCardImageData!
                     , metadata: nil
                     , completion: { _, error in
                        guard error == nil else {
                            print("Failed to upload")
                            return
                        }
                        
                        self.storage.child("certification/\(userUID).png").downloadURL(completion: { url, error in
                            guard let url = url, error == nil else {
                                return
                            }
                            
                            let urlString = url.absoluteString
                            print("DownloadURL : \(urlString)")
                            //                            UserDefaults.standard.set(urlString, forKey: "url")
                        })
                     })
    }
    
    // 패스워드
    func isValidPassword(pw: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,20}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: pw)
    }
    
    // 난수 생성기
    func generateRandomString(_ n: Int) -> String {
        let digits = "abcdefghijklmnopqrstuvwxyz1234567890"
        return String(Array(0..<n).map { _ in digits.randomElement()! })
    }
    
    // false일 경우 가입 불가능, true일 경우 가입 가능
    func emailExistCheck() {
        Auth.auth().fetchSignInMethods(forEmail: "\(userEmailRelay.value)") { provider, error in
            guard self.userEmailRelay.value.count > 3 else { return }
            
            if (error) != nil {
                print(error?.localizedDescription)
            }
            
            // 가입 불가능
            if ((provider?.contains(EmailPasswordAuthSignInMethod)) != nil) {
                self.isVailedUserEmail.accept(.impossible)
                // 가입 가능
            } else {
                self.isVailedUserEmail.accept(.possible)
            }
        }
    }
}
