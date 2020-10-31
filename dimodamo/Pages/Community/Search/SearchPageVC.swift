//
//  SearchPageVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

protocol CommunityPageIndexDelegate {
    func SelectMenuItem(pageIndex: Int)
}

class SearchPageVC: UIPageViewController {
    
    var disposeBag = DisposeBag()
    var pageDelegate: CommunityPageIndexDelegate?
    
    var pageIndex = BehaviorRelay<Int>(value: 0)
    var keyword: String = ""
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "ArticleSearchVC"),
                self.VCInstance(name: "InformationSearchVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        let vc = UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: name)
        
        if name == "ArticleSearchVC" {
            let destinationVC = vc as! ArticleSearchVC
            destinationVC.viewModel.searchKeyword.accept(self.keyword)
            
        } else if name == "InformationSearchVC" {
//            let destinationVC = vc as! ArticleSearchVC
        }
        
        return vc
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
}


extension SearchPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource, SendCommunityPageIndexDelegate {
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
