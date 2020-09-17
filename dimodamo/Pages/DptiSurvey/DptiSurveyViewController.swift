//
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
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet var answers : Array<UIButton>!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progrssTitle: UILabel!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardHorizontalScrollView: UIScrollView!
    @IBOutlet weak var prevBtn: UIButton!
    
    
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
                let value = Float(self!.viewModel.currentNumber.value) / 20
                self?.progrssTitle.text = "\(self!.viewModel.currentNumber.value) / 20"
                UIView.animate(withDuration: self!.animationSpeed) {
                    self?.progress.setProgress(value, animated: true)
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
    let animationSpeed = 0.75
    
    
    @objc func startHighlight(sender : UIButton) {
        // next question card
        
        // ProgressBar Animation
        cardMove(isNextCard: true)
 
        // all answer border color & text color init
        for answer in answers {
            answer.layer.borderColor = UIColor(named: "GRAY - 190")?.cgColor
            answer.setTitleColor(UIColor(named: "GRAY - 170"), for: .normal)
        }
        
        sender.layer.borderColor = UIColor(named: "YELLOW")?.cgColor
        sender.setTitleColor(UIColor(named: "YELLOW"), for: .normal)
        // select answer color change
        
    }
    
    
    // true일 경우 다음 카드, false일 경우 이전 카드
    func cardMove(isNextCard : Bool) {
        
        let direction = isNextCard == true ? 1 : -1
        viewModel.nextCard(isNextCard: isNextCard)
        
        let currentPositionX : Int = Int(cardHorizontalScrollView.contentOffset.x)
        let margin = 20
        let movingStep = (Int(card.frame.width) + margin) * direction
        let destinationPositionX : Int = currentPositionX + movingStep

        UIView.animate(withDuration: animationSpeed) {
//            self.progress.setProgress(self.viewModel.progressBarValue, animated: true)
            self.cardHorizontalScrollView.setContentOffset(CGPoint(x: destinationPositionX, y: 0), animated: false)
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
            answer.tag = cardValue - index
            answer.addTarget(self, action: #selector(startHighlight), for: .touchDown)
            print(answer.tag)
        }
        
        cards.enumerated().forEach { index, card in
            cards[index].layer.cornerRadius = 24
            cards[index].addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
        }
        
        
        
    }
}
