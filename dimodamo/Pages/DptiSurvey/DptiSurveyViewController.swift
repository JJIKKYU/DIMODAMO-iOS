
//  DptiSurveyViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxAnimated

class DptiSurveyViewController: UIViewController {

    let viewModel = DptiSurveyViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var card: UIView!
    @IBOutlet var cards : Array<UIView>!
    @IBOutlet var answers : Array<UIButton>!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progrssTitle: UILabel!
    @IBOutlet var questionTitle: Array<UILabel>!
    @IBOutlet weak var cardHorizontalScrollView: UIScrollView!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet var feedbackCard: Array<UIView>!
    @IBOutlet var feedbackCardTitles: Array<UILabel>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewDesign()
        colorSetting()
        
        
        
        
        prevBtn.rx.tap
            .debounce(RxTimeInterval.seconds(Int(0.3)), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                print("PrevBtn Pressed")
                self?.cardMove(isNextCard: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.currentNumber
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] _ in
                let currentNumber : Int = Int(self!.viewModel.currentNumber.value)
                
                // 가장 첫 번째 문제는 이전으로 버튼이 보이지 않도록
                self?.prevBtn.isHidden = currentNumber == 1 || currentNumber == 21 ? true : false
                
                let value = Float(currentNumber) / 20
                self?.progrssTitle.text = "\(min(currentNumber, 20)) / 20"
                UIView.animate(withDuration: self!.animationSpeed) {
                    self?.progress.setProgress(value, animated: true)
                }
                
                if currentNumber == 6 || currentNumber == 11 || currentNumber == 16 || currentNumber == 21 {
                    self?.feedbackCardShowing(currentNumber: currentNumber)
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.questions
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] _ in
                let questions = self?.viewModel.questions.value
                
                self?.questionTitle.enumerated().forEach { index, question in
                    self?.questionTitle[index].text = questions?[index]
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DptiCalc" {
            let vc = segue.destination as! CalculatingViewController
            vc.a = 10
        }
    }
    

    // MARK: - UI
    
    // Default Animation Speed Variable
    let animationSpeed: Double = 0.75
    var themeColor: UIColor = UIColor.appColor(.yellow)
    
    
    @objc func selectBtn(sender : UIButton) {
 
        // all answer border color & text color init
        for answer in answers {
            answer.layer.borderColor = UIColor.appColor(.gray170).cgColor
            answer.setTitleColor(UIColor.appColor(.gray170), for: .normal)
        }
        
        // select answer color change
        sender.layer.borderColor = themeColor.cgColor
        sender.setTitleColor(themeColor, for: .normal)

        
        // 체크한 값을 배열에 입력
        viewModel.answerCheck(answerTag: sender.tag)
        
        // 카드 이동
        cardMove(isNextCard: true)
    }
    

    // true일 경우 다음 카드, false일 경우 이전 카드
    func cardMove(isNextCard : Bool) {
        if (viewModel.currentNumber.value >= 20) {
            finishSurvey()
        }
        viewModel.nextCard(isNextCard: isNextCard)
        
        let direction = isNextCard == true ? 1 : -1
        
        let currentPositionX : Int = Int(cardHorizontalScrollView.contentOffset.x)
        let margin = 20
        let movingStep = (Int(card.frame.width) + margin) * direction
        let destinationPositionX : Int = currentPositionX + movingStep
        
        // 피드백 카드가 나타나는 특정 넘버에서는 딜레이 존재
        if (self.viewModel.currentNumber.value == 6 || self.viewModel.currentNumber.value == 11 ||
            self.viewModel.currentNumber.value == 16 || self.viewModel.currentNumber.value == 21) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                UIView.animate(withDuration: self.animationSpeed) {
                    self.cardHorizontalScrollView.setContentOffset(CGPoint(x: destinationPositionX, y: 0), animated: false)
                }
            })
        // 특정 카드가 아닐 경우에는 딜레이 없이 바로바로 넘김
        } else {
            UIView.animate(withDuration: animationSpeed) {
                self.cardHorizontalScrollView.setContentOffset(CGPoint(x: destinationPositionX, y: 0), animated: false)
            }
        }
    }
    
    
    func finishSurvey() {
        viewModel.checkType()
        print("설문 클리어!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
            self.performSegue(withIdentifier: "DptiResult", sender: nil)
        })
        
    }
}


// MARK: - View Design Extension

extension DptiSurveyViewController {
    func cardViewDesign() {
        
        let cardValue : Int = 2
        
        // answer Color & Border & Border Color Init
        answers.enumerated().forEach { (index, answer) in
            answer.layer.cornerRadius = 16
            answer.layer.borderWidth = 2
            answer.layer.borderColor = UIColor(named: "GRAY - 190")?.cgColor
            
            let questionNumber = (index / 5) + 1
            var reverse: Int = 1
            
            // 아래의 문제의 경우에는 tag의 값을 반대로 책정
            if questionNumber == 3 || questionNumber == 5 || questionNumber == 6 || questionNumber == 8 ||
               questionNumber == 10 || questionNumber == 12 || questionNumber == 15 || questionNumber == 17 ||
               questionNumber == 19 || questionNumber == 20 {
                reverse = -1
            } else { reverse = 1 }
            
            answer.tag = (cardValue - (index % 5)) * reverse
            answer.addTarget(self, action: #selector(selectBtn), for: .touchDown)
        }
        
        let margin: CGFloat = 40 // left margin + Right margin
        
        cards.enumerated().forEach { index, card in
            let widthConstraint = cards[index].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - margin)
            cards[index].addConstraint(widthConstraint)
            cards[index].layer.cornerRadius = 24
            cards[index].addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
        }
        
        // feedbackCardSetting
        feedbackCard.forEach { card in
            card.alpha = 0
        }
    }
    
    func feedbackCardShowing(currentNumber: Int) {
        print("호출")
        
        switch currentNumber {
        case 5:
            self.themeColor = UIColor.appColor(.yellow)
            self.progress.progressTintColor = self.themeColor
            break
        case 6:
            animateFeeedbackCard(index: 0, prevColor: UIColor.appColor(.yellow), changeAppColor: UIColor.appColor(.purple))
            break
        case 11:
            animateFeeedbackCard(index: 1, prevColor: UIColor.appColor(.purple), changeAppColor: UIColor.appColor(.blue))
            break
        case 16:
            animateFeeedbackCard(index: 2, prevColor: UIColor.appColor(.blue), changeAppColor: UIColor.appColor(.pink))
            break
        case 21:
            animateFeeedbackCard(index: 3, prevColor: UIColor.appColor(.pink), changeAppColor: UIColor.appColor(.pink))
            break
        default:
            break
        }
    }
    
    func animateFeeedbackCard(index: Int, prevColor: UIColor, changeAppColor: UIColor) {
        feedbackCardTitles[index].text = FeedbackCardTitle().title[index]
        feedbackCardTitles[index].textColor = prevColor
        UIView.animate(withDuration: self.animationSpeed - 0.35) { [weak self] in
            self?.feedbackCard[index].alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            UIView.animate(withDuration: self.animationSpeed) { [weak self] in
                self?.themeColor = changeAppColor
                self?.progress.progressTintColor = self?.themeColor
                self?.feedbackCard[index].alpha = 0
            }
        })
    }
    
    func colorSetting() {
        prevBtn.tintColor = UIColor.appColor(.system)
        progrssTitle.tintColor = UIColor.appColor(.system)
    }
}
