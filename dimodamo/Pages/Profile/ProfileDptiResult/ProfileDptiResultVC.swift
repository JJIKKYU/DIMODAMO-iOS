//
//  ProfileDptiResultVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/07.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Lottie

class ProfileDptiResultVC: UIViewController {
    
    @IBOutlet weak var resultCardView: UIView! {
        didSet {
            resultCardView.layer.cornerRadius = 24
            let aspectRatioHeight: CGFloat = (348 / 414) * UIScreen.main.bounds.width
            resultCardView.heightAnchor.constraint(equalToConstant: aspectRatioHeight).isActive = true
            resultCardView.appShadow(.s12)
        }
    }
    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var typeIcon: UIImageView! {
        didSet {
            typeIcon.appShadow(.s12)
        }
    }
    @IBOutlet weak var typeDesc: UITextView!
    @IBOutlet weak var typeChar: UIImageView!
    @IBOutlet weak var patternBG: UIImageView!
    @IBOutlet weak var positionIcon: UIImageView!
    @IBOutlet weak var positionDesc: UILabel! {
        didSet {
            positionDesc.textColor = UIColor.appColor(.system)
        }
    }
    @IBOutlet var designs : [UILabel]! {
        didSet {
            for design in designs {
                design.textColor = UIColor.appColor(.system)
            }
        }
    }
    @IBOutlet var designsDesc : [UILabel]!
    @IBOutlet weak var toolImg: UIImageView!
    @IBOutlet weak var toolName: UILabel! {
        didSet {
            toolName.textColor = UIColor.appColor(.system)
        }
    }
    @IBOutlet weak var toolDesc: UITextView!
    @IBOutlet weak var todo: UITextView!
    @IBOutlet var circleNumbers : [UILabel]! {
        didSet {
            for number in circleNumbers {
                number.layer.cornerRadius = 16
                number.layer.masksToBounds = true
                number.backgroundColor = UIColor.appColor(.system)
            }
        }
    }
    
    @IBOutlet weak var allTypeBtn: UIButton! {
        didSet {
            allTypeBtn.layer.cornerRadius = 16
            allTypeBtn.layer.masksToBounds = true
        }
    }
    
    let viewModel = ProfileDptiResultViewModel()
    var disposeBag = DisposeBag()
    
    
    /*
     ViewLoad
     */
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animate()
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
        }, completion: nil)
    }
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray190)
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setColors()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.colorHex
            .map { $0 }
            .asDriver(onErrorJustReturn: UIColor.appColor(.system))
            .drive(resultCardView.rx.backgroundColor)
            .disposed(by: disposeBag)

        // UILabel Binding
        viewModel.resultObservable.flatMap { [weak self] in
            Observable.from([
                ($0.title, self?.typeTitle),
                ($0.design[0], self?.designs[0]),
                ($0.design[1], self?.designs[1]),
                ($0.toolName, self?.toolName),
                ($0.position, self?.positionDesc),
            ])
        }
        .asDriver(onErrorJustReturn: ("", nil))
        .drive(onNext: { text, label in
            label?.text = text
        })
        .disposed(by: disposeBag)

        // TypeDesc Binding
        viewModel.typeDesc
            .map { "\($0)"}
            .asDriver(onErrorJustReturn: "")
            .drive(typeDesc.rx.text)
            .disposed(by: disposeBag)


        viewModel.designsDesc
            .map{ "\($0[0])"}
            .asDriver(onErrorJustReturn: "")
            .drive(designsDesc[0].rx.text)
            .disposed(by: disposeBag)


        viewModel.designsDesc
            .map{ "\($0[1])"}
            .asDriver(onErrorJustReturn: "")
            .drive(designsDesc[1].rx.text)
            .disposed(by: disposeBag)


        // UITextView Binding
        viewModel.resultObservable.flatMap { [weak self] in
            Observable.from([
                ($0.toolDesc, self?.toolDesc),
                ($0.todo, self?.todo)
            ])
        }
        .asDriver(onErrorJustReturn: ("", nil))
        .drive(onNext: { text, textView in
            textView?.text = text
        })
        .disposed(by: disposeBag)

        // UIImage Binding
        viewModel.resultObservable.flatMap { [weak self] in
            Observable.from([
                ("BC_Type_\($0.shape)", self?.typeIcon),
                ("BC_BG_P_\($0.shape)", self?.patternBG),
                ("Icon_\($0.type)", self?.positionIcon),
                ($0.toolImg, self?.toolImg)
            ])
        }
        .asDriver(onErrorJustReturn: ("", nil))
        .drive(onNext: { imageName, uiImage in
            uiImage!.image = UIImage(named : imageName)
        })
        .disposed(by: disposeBag)
        
        /*
         LottieChar
         */
        viewModel.typeGenderForLottie
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { type in
                // 기본값이 아닐때
                if type != "" {
                    print("로띠를 부릅니당")
                    self.lottieChar(typeGender: type)
                } else {
                    
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func lottieChar(typeGender: String) {
        let animationView = Lottie.AnimationView.init(name: "\(typeGender)")
//        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
//        resultCardView.translatesAutoresizingMaskIntoConstraints = false
        resultCardView.addSubview(animationView)
//        typeChar.rightAnchor.constraint(equalTo: resultCardView.rightAnchor, constant: 0).isActive = true
//        typeChar.bottomAnchor.constraint(equalTo: resultCardView.bottomAnchor, constant: 0).isActive = true
        
        

        animationView.layer.cornerRadius = 24
        animationView.play()
        animationView.loopMode = .loop
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "AllTypeDptiVC":
            let destination = segue.destination
            destination.modalPresentationStyle = .fullScreen
            destination.modalTransitionStyle = .coverVertical
            break
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    
    @IBAction func pressedAllTypeBtn(_ sender: Any) {
        performSegue(withIdentifier: "AllTypeDptiVC", sender: nil)
    }
    
}
