
//  DptiSurveyViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Lottie


class DptiSurveyViewController: UIViewController {
    
    let viewModel = DptiSurveyViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet var cardsHeightConstraint: Array<NSLayoutConstraint>! {
        didSet {
            let screenHeight = UIScreen.main.bounds.height
            
            // SE2
            if screenHeight < 700 {
                for height in cardsHeightConstraint {
                    height.constant = 530
                }
            }

        }
    }
    @IBOutlet weak var cardCardView: UIView!
    @IBOutlet weak var card: UIView!
    @IBOutlet var cards : Array<UIView>!
    @IBOutlet var answersHeightConstraint: Array<NSLayoutConstraint>! {
        didSet {
            
            let screenHeight = UIScreen.main.bounds.height
            
            // SE2
            if screenHeight < 700 {
                for answerHeight in answersHeightConstraint {
                    answerHeight.constant = 45
                }
            }
        }
    }
    @IBOutlet var answers : Array<UIButton>!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressTitleNav: UINavigationItem!
    @IBOutlet var questionTitle: Array<UILabel>!
    @IBOutlet weak var cardHorizontalScrollView: UIScrollView!
    @IBOutlet weak var prevBtnNav: UIBarButtonItem!
    @IBOutlet weak var closeBtnNav: UIBarButtonItem!
    @IBOutlet var feedbackCard: Array<UIView>!
    @IBOutlet var feedbackCardTitles: Array<UILabel>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        cardViewDesign()
        navigationBarDesign()
        
        
        
        prevBtnNav.rx.tap
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
                self?.prevBtnNav.isEnabled = currentNumber == 1 || currentNumber == 21 ? false : true
                self?.prevBtnNav.tintColor = currentNumber == 1 || currentNumber == 21 ? UIColor.clear : UIColor.appColor(.system)
                
                let value = Float(currentNumber) / 20
                self?.progressTitleNav.title = "\(min(currentNumber, 20)) / 20"
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
        if segue.identifier == "DptiResult" {
            let vc = segue.destination as! DptiResultViewController
            vc.viewModel.setType(type: viewModel.checkType())
            vc.viewModel.setGender(gender: viewModel.gender)
        }
    }
    
    
    // MARK: - UI
    
    // Default Animation Speed Variable
    let animationSpeed: Double = 0.5
    var themeColor: UIColor = UIColor.appColor(.yellow)
    
   
    
    
    @objc func selectBtn(sender : UIButton) {
        
        // all answer border color & text color init
        // 선택한 최근 5개만 초기화 하도록 합시다
        for answer in answers {
            guard let answerTitle = answer.titleLabel?.text else {
                continue
            }
            let defaultBtnAttribute = NSAttributedString(string: "\(answerTitle)",
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.appColor(.gray170),
                                                                       NSAttributedString.Key.font : UIFont(name: "Apple SD Gothic Neo SemiBold", size: 17) as Any
                                                          ])
            answer.layer.borderColor = UIColor.appColor(.gray170).cgColor
            answer.setAttributedTitle(defaultBtnAttribute, for: .normal)
            answer.isSelected = false // 이전 버튼을 다시 누를 수 있또록 초기화
        }
        
        // 선택한 답변 변경
        sender.layer.borderColor = themeColor.cgColor
        sender.setTitleColor(themeColor, for: .normal)
        
        guard let senderTtitle = sender.titleLabel?.text else {
            return
        }
        // 선택한 답변의 텍스트 컬러 및 굵기 수정
        let selectedBtnAttribute = NSAttributedString(string: "\(senderTtitle)",
                                                      attributes: [NSAttributedString.Key.foregroundColor : themeColor,
                                                                   NSAttributedString.Key.font : UIFont(name: "Apple SD Gothic Neo Bold", size: 17) as Any
                                                      ])
        
        sender.setAttributedTitle(selectedBtnAttribute, for: .normal)
        
        
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
    
    @IBAction func closeBtn(_ sender: Any) {
        let alert = AlertController(title: "정말 그만두시겠습니까?", message: "진행과정은 저장되지 않습니다", preferredStyle: .alert)
        alert.setTitleImage(UIImage(named: "alertError"))
        let actionOK = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let actionCancle = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(actionOK)
        alert.addAction(actionCancle)
        present(alert, animated: true, completion: nil)
    }
    
    func finishSurvey() {
        _ = viewModel.checkType()
        print("설문 클리어!")
        self.lottieSetting()
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
            answer.layer.borderWidth = 1.5
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
            answer.isExclusiveTouch = true

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
            card.layer.cornerRadius = 24
        }
    }
    
    func feedbackCardShowing(currentNumber: Int) {
        print("호출")
        
        switch currentNumber {
        case 5:
            self.themeColor = UIColor.appColor(.yellowDark)
            self.progress.progressTintColor = self.themeColor
            break
        case 6:
            animateFeeedbackCard(index: 0, prevColor: UIColor.appColor(.yellow), changeAppColor: UIColor.appColor(.purpleDark))
            break
        case 11:
            animateFeeedbackCard(index: 1, prevColor: UIColor.appColor(.purple), changeAppColor: UIColor.appColor(.blueDark))
            break
        case 16:
            animateFeeedbackCard(index: 2, prevColor: UIColor.appColor(.blue), changeAppColor: UIColor.appColor(.pinkDark))
            break
        case 21:
            animateFeeedbackCard(index: 3, prevColor: UIColor.appColor(.pink), changeAppColor: UIColor.appColor(.pinkDark))
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
    
    func navigationBarDesign() {
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appColor(.system)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //
        let navBar = self.navigationController?.navigationBar
        navBar?.backgroundColor = UIColor.appColor(.white255)
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
    }
}

//MARK: - Lottie

extension DptiSurveyViewController {
    func lottieSetting() {
        let animationView = Lottie.AnimationView.init(name: "Extract_Mobile")
//        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
//        resultCardView.translatesAutoresizingMaskIntoConstraints = false
        cardCardView.addSubview(animationView)
        animationView.topAnchor.constraint(equalTo: cardCardView.topAnchor, constant: 0).isActive = true
        animationView.leftAnchor.constraint(equalTo: cardCardView.leftAnchor, constant: 0).isActive = true
        animationView.rightAnchor.constraint(equalTo: cardCardView.rightAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: cardCardView.bottomAnchor, constant: 0).isActive = true
        
        animationView.play()
        animationView.loopMode = .loop
    }
}
