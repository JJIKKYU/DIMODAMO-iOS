//
//  ProfileDptiResultVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/07.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ProfileDptiResultVC: UIViewController {

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
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedAllTypeBtn(_ sender: Any) {
        performSegue(withIdentifier: "AllTypeDptiVC", sender: nil)
    }
    
}
