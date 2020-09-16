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

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet var answers : Array<UIButton>!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progrssTitle: UILabel!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardHorizontalScrollView: UIScrollView!
    
    let viewModel = DptiSurveyViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewDesign()

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
    
    
    
    @objc func startHighlight(sender : UIButton) {
        // next question card
        viewModel.nextCard()
        
        // ProgressBar Animation
        UIView.animate(withDuration: 0.75, animations: {
            self.progress.setProgress(self.viewModel.progressBarValue, animated: true)
            self.cardHorizontalScrollView.setContentOffset(CGPoint(x: self.card.frame.width + 20, y: 0), animated: false)
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
        
        card.layer.cornerRadius = 24
        card.addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
    }
}
