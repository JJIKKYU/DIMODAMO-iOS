//
//  ManitoChatVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FriendPageVC: UIPageViewController {
    
    var disposeBag = DisposeBag()
    
    var pageIndex = BehaviorRelay<Int>(value: 0)
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "MainManitoChatVC"),
                self.VCInstance(name: "MainManitoChatVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        let vc = UIStoryboard(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: name)
        
        return vc
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        
        pageIndex
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { index in
                
                
                self.setViewControllers([self.VCArray[index]],
                                        direction: index == 0 ? .reverse : .forward,
                                        animated: true,
                                        completion: nil)
                
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

}
