//
//  prViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/18.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class prViewController: UIViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationItem.rightBarButtonItem = scrapNavbarItem
//        navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.hideTransparentNavigationBar()
        animate()
    }
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.white255)
//        navigationController?.navigationBar.barTintColor = UIColor.dptiDarkColor("M_PI")
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setColors()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressedpr1(_ sender: Any) {
        performSegue(withIdentifier: "pr_2", sender: sender)
    }
    @IBAction func pressedpr2(_ sender: Any) {
        performSegue(withIdentifier: "pr_3", sender: sender)
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
