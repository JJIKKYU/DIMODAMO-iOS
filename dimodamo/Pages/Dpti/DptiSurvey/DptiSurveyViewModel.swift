//
//  DptiSurveyViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

import FirebaseAuth
import FirebaseFirestore

class DptiSurveyViewModel {
    
    lazy var surveyObservable = BehaviorRelay<[DptiSurvey]>(value: [])
        
    lazy var currentNumber = BehaviorRelay<Int>(value: 1)
            
    lazy var questions = BehaviorRelay<[String]>(value: [])
    
    lazy var progressBarValue = Float(currentNumber.value) / 20
    
    var userSurveyAnswer : UserSurveyAnswer = UserSurveyAnswer()
    
    var gender: String = ""
    
    init() {
        _ = APIService.fetchLocalJsonRx(fileName: "Survey")
            .map { data -> [String] in
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                let jsonQuestions : [String] = json?["Question"] as! [String]
            
                return jsonQuestions
            }
        .map { questions in
            let dptiSurveys : [DptiSurvey] = []
            self.questions.accept(questions)
            
            return dptiSurveys
        }
        .take(1)
        .bind(to: surveyObservable)
        
        
        // 파이어베이스에서 성별체크
        // -> 할 필요가 없어졌음 -> 앞단계에서 성별 체크 진행
        /*
        let user: String = Auth.auth().currentUser?.uid ?? ""
        let docRef = Firestore.firestore().collection("users").document(user)
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                if let gender: String = document.data()?["gender"] as? String {
                    self.gender = gender
                }
                print(self.gender)
            } else {
                print("documnet does not exist")
            }
        }
        */
    }
    
    func nextCard(isNextCard : Bool) {
        if (currentNumber.value == 0) { return }
        
        print("성별을 받았었습니다 : \(self.gender)")
        
        let flag : Int = isNextCard == true ? 1 : -1
        
        progressBarValue = Float(currentNumber.value) / 20
        currentNumber.accept(currentNumber.value + flag)
    }
    
    func answerCheck(answerTag : Int) {
        userSurveyAnswer.answers[String(currentNumber.value)] = answerTag
        print(userSurveyAnswer)
    }
    
    
    // userSurveyAnswer를 기반으로 checkType실행
    func checkType() -> String {
        var typeEI: Int = 0;
        var typeSN: Int = 0;
        var typeTF: Int = 0;
        var typeJP: Int = 0;
        
        userSurveyAnswer.answers.enumerated().forEach { (index, answer) in
            let key: Int = Int(answer.key)!
            
            if key <= 5 {
                typeEI += answer.value
            } else if key <= 10 {
                typeSN += answer.value
            } else if key <= 15 {
                typeTF += answer.value
            } else if key <= 20 {
                typeJP += answer.value
            }
        }
        
        print("typeEI : \(typeEI), typeSN : \(typeSN), typeTF : \(typeTF), typeJP : \(typeJP)")
        
        var isTypeEI: Bool = false
        var isTypeSN: Bool = false
        var isTypeTF: Bool = false
        var isTypeJP: Bool = false
        
        if abs(typeEI) <= abs(typeSN) {
            isTypeSN = true
        } else {
            isTypeEI = true
        }
        
        if abs(typeTF) <= abs(typeJP) {
            isTypeJP = true
        } else {
            isTypeTF = true
        }
        
        print("isTypeEI : \(isTypeEI), isTypeSN : \(isTypeSN), isTypeTF : \(isTypeTF), isTypeJP: \(isTypeJP)")
        
        var figureType: String = ""
        var colorType: String = ""
        
        if isTypeEI {
            if typeEI < 0 { figureType = "E" }
            else { figureType = "I" }
        } else if isTypeSN {
            if typeSN < 0 { figureType = "S" }
            else { figureType = "N" }
        }
        
        if isTypeTF {
            if typeTF < 0 { colorType = "T" }
            else { colorType = "F" }
        } else if isTypeJP {
            if typeJP < 0 { colorType = "J" }
            else { colorType = "P" }
        }
        
        let finalType: String = "\(self.gender)_\(colorType)\(figureType)"
        
        print("finalType : \(finalType)")
    
        
        return finalType
    }
    
    
}
