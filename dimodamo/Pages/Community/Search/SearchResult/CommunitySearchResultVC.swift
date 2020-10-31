//
//  CommunitySearchResultVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

protocol SendCommunityPageIndexDelegate {
    func SelectBtn(padgeIndex: Int)
}

class CommunitySearchResultVC: UIViewController {

    
    @IBOutlet weak var artboardBtn: UIButton!
    @IBOutlet weak var layerBtn: UIButton!
    @IBOutlet weak var bar: UIView! {
        didSet {
            bar.layer.cornerRadius = 2
            bar.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var barLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var barWidthConstraint: NSLayoutConstraint!
    
    let viewModel = CommunitySearchResultViewModel()
    var disposeBag = DisposeBag()
    
    var btnDelegate: SendCommunityPageIndexDelegate?
    var keyword: String = "여기는 커뮤니티 리설뚜 브이쒸"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        viewModel.activateSection
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                
                self?.view.layoutIfNeeded()
                
                
                switch index {
                // 디모 아트보드
                case 0:
                    self?.barWidthConstraint.constant = 115
                    self?.barLeadingConstraint.constant = 24
                    
                    self?.artboardBtn.setTitleColor(UIColor.appColor(.textSmall), for: .normal)
                    self?.layerBtn.setTitleColor(UIColor.appColor(.white235), for: .normal)
                    
                    
                    
                    break
                    
                // 다모 레이어
                case 1:
                    self?.barWidthConstraint.constant = 100
                    self?.barLeadingConstraint.constant = 153
                    
                    self?.layerBtn.setTitleColor(UIColor.appColor(.textSmall), for: .normal)
                    self?.artboardBtn.setTitleColor(UIColor.appColor(.white235), for: .normal)
                    
                    
                    
                    break
                    
                    
                default:
                    break
                }
                
                UIView.animate(withDuration: 0.5) {
                    self?.view.layoutIfNeeded()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func pressedArtboardBtn(_ sender: Any) {
        btnDelegate?.SelectBtn(padgeIndex: 0)
        viewModel.activateSection.accept(0)
    }
    
    @IBAction func pressedLayerBtn(_ sender: Any) {
        btnDelegate?.SelectBtn(padgeIndex: 1)
        viewModel.activateSection.accept(1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchPageVC" {
            let destinationVC = segue.destination as! SearchPageVC
            destinationVC.pageDelegate = self
            
            // 키워드 전달 
            destinationVC.keyword = self.keyword
            btnDelegate = destinationVC
//            let index = viewModel.isActiveEmailView.value == true ? 0 : 1
//            destinationVC.pageIndex.accept(index)
        }
    }
}

extension CommunitySearchResultVC: CommunityPageIndexDelegate {
    func SelectMenuItem(pageIndex: Int) {
        viewModel.activateSection.accept(pageIndex)
    }
    
    
}
