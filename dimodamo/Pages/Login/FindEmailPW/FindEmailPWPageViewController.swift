//
//  FindEmailPWPageViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

protocol PageIndexDelegate {
    func SelectMenuItem(pageIndex: Int)
}

class FindEmailPWPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageDelegate: PageIndexDelegate?
    var btnDelegate: BtnPageIndexDelegate?
    
    var disposeBag = DisposeBag()
    
    var pageIndex = BehaviorRelay<Int>(value: 0)
    
    
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "FindEmailVC"),
                self.VCInstance(name: "FindPWVC")]
    }()

    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: name)
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
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArray.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewContoller = viewControllers?.first, let firstViewContollerIndex = VCArray.firstIndex(of: firstViewContoller) else {
            return 0
        }
        return firstViewContollerIndex
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        pageIndex
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { index in
                self.setViewControllers([self.VCArray[index]],
                                        direction: index == 0 ? .forward : .reverse,
                                        animated: true,
                                        completion: nil)
                
            })
            .disposed(by: disposeBag)

    }
    
}

// MARK: - 현재 페이지에 따라서 버튼 selected 상태가 변경되도록 하기 위한 델리게이트

extension FindEmailPWPageViewController : BtnPageIndexDelegate {
    func SelectMenuBtn(BtnIndex: Int) {
        pageIndex.accept(BtnIndex)
        print("버튼 인덱스 : \(BtnIndex)")
    }
}
