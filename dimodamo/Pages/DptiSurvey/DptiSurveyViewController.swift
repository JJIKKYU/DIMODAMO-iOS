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
            
//        viewModel.question
//            .map { "\($0)"}
//            .asDriver(onErrorJustReturn: "")
//            .drive(cardTitle.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.currentNumber
//            .map {"Q\($0)" }
//            .asDriver(onErrorJustReturn: "")
//            .drive(questionNumber.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.currentNumber
//            .map { "\($0) / 20"}
//            .asDriver(onErrorJustReturn: "")
//            .drive(progrssTitle.rx.text)
//            .disposed(by: disposeBag)
    }
    

    // MARK: - UI
    

    
    
    @objc func startHighlight(sender : UIButton) {
        // next question card
        viewModel.nextCard()
        
        // ProgressBar Animation
        UIView.animate(withDuration: 0.75, animations: {
            self.progress.setProgress(self.viewModel.progressBarValue, animated: true)
            self.cardMove(isNextCard: true)
        })
        
        
        
 
        // all answer border color & text color init
        for answer in answers {
            answer.layer.borderColor = UIColor(named: "GRAY - 190")?.cgColor
            answer.setTitleColor(UIColor(named: "GRAY - 170"), for: .normal)
        }
        
        // select answer color change
        sender.layer.borderColor = UIColor(named: "YELLOW")?.cgColor
        sender.setTitleColor(UIColor(named: "YELLOW"), for: .normal)
    }
    
    // true일 경우 다음 카드, false일 경우 이전 카드
    func cardMove(isNextCard : Bool) {
        
        let direction = isNextCard == true ? 1 : -1
        
        let currentPositionX : Int = Int(cardHorizontalScrollView.contentOffset.x)
        let margin = 20
        let movingStep = (Int(card.frame.width) + margin) * direction
        let destinationPositionX : Int = currentPositionX + movingStep

        UIView.animate(withDuration: 0.75) {
            self.cardHorizontalScrollView.setContentOffset(CGPoint(x: destinationPositionX, y: 0), animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

// MARK: - View Design Extension

extension DptiSurveyViewController {
    func cardViewDesign() {
        // answer Color & Border & Border Color Init
        for answer in answers {
            answer.layer.cornerRadius = 16
            answer.layer.borderWidth = 2
            answer.layer.borderColor = UIColor(named: "GRAY - 190")?.cgColor
            answer.addTarget(self, action: #selector(startHighlight), for: .touchDown)
        }
        
        cards.enumerated().forEach { index, card in
            cards[index].layer.cornerRadius = 24
            cards[index].addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
        }
        
        
        
    }
}
