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
    var pageDelegate: CommunityPageIndexDelegate?
    
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


        self.delegate = self
        self.dataSource = self
        
        
        
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

extension FriendPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource, SendCommunityPageIndexDelegate {
    func SelectBtn(padgeIndex: Int) {
        pageIndex.accept(padgeIndex)
    }
    
    
    // 애니메이션이 끝날 경우에 델리게이트를 통해서 현재 페이지를 Int로 전달
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?.first,
               let index = VCArray.firstIndex(of: currentVC) {
                self.pageDelegate?.SelectMenuItem(pageIndex: index)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard VCArray.count > previousIndex else {
            return nil
        }
        
        return VCArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArray.count else {
            return nil
        }
        
        guard VCArray.count > nextIndex else {
            return nil
        }
        
        return VCArray[nextIndex]
    }
    
    
}
