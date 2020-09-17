//
//  CalculatingViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class CalculatingViewController: UIViewController {
    
    var a : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func testbtn(_ sender: Any) {
        performSegue(withIdentifier: "DptiResult", sender: nil)
    }
    
}
