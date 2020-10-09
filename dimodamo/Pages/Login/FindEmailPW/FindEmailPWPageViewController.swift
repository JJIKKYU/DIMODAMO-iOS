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
    
    var firstPage = BehaviorRelay<Int>(value: 0)
    
    var disposeBag = DisposeBag()
    
    var pageIndex: Int = 0
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "FindEmailVC"),
                self.VCInstance(name: "FindPWVC")]
    }()

    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        self.pageDelegate?.SelectMenuItem(pageIndex: viewControllerIndex)
        
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
        self.pageDelegate?.SelectMenuItem(pageIndex: viewControllerIndex)
        
        
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
        print(firstViewContollerIndex)
        
        return firstViewContollerIndex
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
//        if VCArray[self.firstPage] != nil {
//            setViewControllers([VCArray[self.firstPage]], direction: .forward, animated: true, completion: nil)
//        }
        
//
        if let findEmailVC = VCArray.first {
            setViewControllers([findEmailVC], direction: .forward, animated: true, completion: nil)
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
