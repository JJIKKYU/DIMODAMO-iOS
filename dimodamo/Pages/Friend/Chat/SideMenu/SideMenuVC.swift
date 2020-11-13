//
//  SideMenuVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = UIColor.appColor(.white255)
            backgroundView.layer.cornerRadius = 16
            backgroundView.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
