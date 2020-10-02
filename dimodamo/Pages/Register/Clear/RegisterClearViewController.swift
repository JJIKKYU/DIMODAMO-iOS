//
//  RegisterClearViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/02.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class RegisterClearViewController: UIViewController {

    @IBOutlet weak var startDptiBtn: UIButton!
    @IBOutlet weak var nextTryBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()

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


extension RegisterClearViewController {
    func viewDesign() {
        startDptiBtn.layer.cornerRadius = 16
        nextTryBtn.layer.cornerRadius = 16
    }
}
