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

class DptiSurveyViewModel {
    
    lazy var surveyObservable = BehaviorRelay<[DptiSurvey]>(value: [])
    
    lazy var surveys : [DptiSurvey] = []
    
    lazy var currentSurveyObservable = BehaviorRelay<DptiSurvey>(value: surveys[self.currentNumber.value])
    
    lazy var currentNumber = BehaviorRelay<Int>(value: 1)
            
    lazy var questions = BehaviorRelay<[String]>(value: [])
    
    lazy var progressBarValue = Float(currentNumber.value) / 20
    
    var userSurveyAnswer : UserSurveyAnswer = UserSurveyAnswer()
    
    init() {
        _ = APIService.fetchLocalJsonRx(fileName: "Survey")
            .map { data -> [String] in
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                let jsonQuestions : [String] = json?["Question"] as! [String]
            
                return jsonQuestions
            }
        .map { questions in
            var dptiSurveys : [DptiSurvey] = []
            self.questions.accept(questions)
            
            questions.enumerated().forEach { (index, question) in
                let dptiSurvey = DptiSurvey(number: index + 1, question: question)
                dptiSurveys.append(dptiSurvey)
                self.surveys.append(dptiSurvey)
                print(dptiSurvey)
            }
            return dptiSurveys
        }
        .take(1)
        .bind(to: surveyObservable)
    }
    
    func nextCard(isNextCard : Bool) {
        if (currentNumber.value >= 21 || currentNumber.value == 0) { return }
        
        let flag : Int = isNextCard == true ? 1 : -1
        
        progressBarValue = Float(currentNumber.value) / 20
        currentNumber.accept(currentNumber.value + flag)
    }
    
    func answerCheck(answerTag : Int) {
        userSurveyAnswer.answers[String(currentNumber.value)] = answerTag
        print(userSurveyAnswer)
    }
    
    
    // userSurveyAnswer를 기반으로 checkType실행
    func checkType() {
        
    }
    
    
}
