
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewDesign()
        
        
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
                if (currentNumber == 1) {
                    self?.prevBtn.isHidden = true
                } else {
                    self?.prevBtn.isHidden = false
                }
                
                let value = Float(currentNumber) / 20
                self?.progrssTitle.text = "\(currentNumber) / 20"
                UIView.animate(withDuration: self!.animationSpeed) {
                    self?.progress.setProgress(value, animated: true)
                }
                
                switch currentNumber {
                case 5:
                    self?.themeColor = "YELLOW"
                    self?.progress.tintColor = UIColor(named: "\(self!.themeColor)")
                    break
                case 6:
                    self?.themeColor = "PURPLE"
                    self?.progress.tintColor = UIColor(named: "\(self!.themeColor)")
                    break
                case 11:
                    self?.themeColor = "BLUE"
                    self?.progress.tintColor = UIColor(named: "\(self!.themeColor)")
                    break
                case 16:
                    self?.themeColor = "PINK"
                    self?.progress.tintColor = UIColor(named: "\(self!.themeColor)")
                    break
                default:
                    break
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
//        viewModel.currentNumber.map {
//            Float($0) / 20
//        }
//        .bind { [weak self] _ in
//            self?.progress.rx.progress
//        }
//        .disposed(by: disposeBag)
            
//        viewModel.question
//            .map { "\($0)"}
//            .asDriver(onErrorJustReturn: "")
//            .drive(cardTitle.rx.text)
//            .disposed(by: disposeBag)

    }
    

    // MARK: - UI
    
    // Default Animation Speed Variable
    let animationSpeed: Double = 0.75
    var themeColor: String = "YELLOW"
    
    
    @objc func selectBtn(sender : UIButton) {
 
        // all answer border color & text color init
        for answer in answers {
            answer.layer.borderColor = UIColor(named: "GRAY - 190")?.cgColor
            answer.setTitleColor(UIColor(named: "GRAY - 170"), for: .normal)
        }
        
        sender.layer.borderColor = UIColor(named: "\(self.themeColor)")?.cgColor
        sender.setTitleColor(UIColor(named: "\(self.themeColor)"), for: .normal)
        // select answer color change
        
        // 체크한 값을 배열에 입력
        viewModel.answerCheck(answerTag: sender.tag)
        
        // 카드 이동
        cardMove(isNextCard: true)
    }
    
    
    // true일 경우 다음 카드, false일 경우 이전 카드
    func cardMove(isNextCard : Bool) {
        if (viewModel.currentNumber.value >= 20) {
            finishSurvey()
            return
        }
        viewModel.nextCard(isNextCard: isNextCard)
        
        let direction = isNextCard == true ? 1 : -1
        
        let currentPositionX : Int = Int(cardHorizontalScrollView.contentOffset.x)
        let margin = 20
        let movingStep = (Int(card.frame.width) + margin) * direction
        let destinationPositionX : Int = currentPositionX + movingStep

        UIView.animate(withDuration: animationSpeed) {
//            self.progress.setProgress(self.viewModel.progressBarValue, animated: true)
            self.cardHorizontalScrollView.setContentOffset(CGPoint(x: destinationPositionX, y: 0), animated: false)
        }
    }
    
    func finishSurvey() {
        print("설문 클리어!")
        performSegue(withIdentifier: "DptiCalc", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DptiCalc" {
            let vc = segue.destination as! CalculatingViewController
            vc.a = 10
        }
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
            
            answer.tag = (cardValue - (index % 5))
            answer.addTarget(self, action: #selector(selectBtn), for: .touchDown)
            print(answer.tag)
        }
        
        let margin: CGFloat = 40 // left margin + Right margin
        
        cards.enumerated().forEach { index, card in
            let widthConstraint = cards[index].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - margin)
            cards[index].addConstraint(widthConstraint)
            cards[index].layer.cornerRadius = 24
            cards[index].addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
        }
        
        
        
    }
}
