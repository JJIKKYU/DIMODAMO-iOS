//
//  DptiResultViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/11.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DptiResultViewController: UIViewController {

    @IBOutlet weak var resultCardView: UIView!
    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var circleNumber: UILabel!
    
    @IBOutlet var circleNumbers : Array<UILabel>?
    
    let viewModel = DptiResultViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title Binding
        viewModel.typeTitle
            .map { "\($0)"}
            .asDriver(onErrorJustReturn: "")
            .drive(typeTitle.rx.text)
            .disposed(by: disposeBag)
        
        resultCardViewInit()
        circleNumberSetting()
    
        
    }

    func resultCardViewInit() {
        resultCardView.layer.cornerRadius = 24
        resultCardView.addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
    }
    
    func circleNumberSetting() {
        for circleNumber in circleNumbers! {
            circleNumber.layer.cornerRadius = 16
            circleNumber.layer.masksToBounds = true
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

