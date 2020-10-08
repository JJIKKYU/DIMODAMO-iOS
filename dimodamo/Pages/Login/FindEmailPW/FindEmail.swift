//
//  FindEmail.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class FindEmail: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pendingPage: Int?
    let identifiers: NSArray = ["FindEmailVC", "FindPWVC"]
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "FindEmailVC"),
                self.VCInstance(name: "FindPWVC")]
    }()
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

            guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }

            let previousIndex = viewControllerIndex - 1
            //        print(previousIndex)

            if previousIndex < 0 {
                return VCArray.last
            } else {
                return VCArray[previousIndex]
            }
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }
            let nextIndex = viewControllerIndex + 1

            if nextIndex >= VCArray.count {
                return VCArray.first
            } else {
                return VCArray[nextIndex]
            }
        }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "FindEmailVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = VCArray.first{
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
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
