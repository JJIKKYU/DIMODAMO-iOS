//
//  MainViewController.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/05/30.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func sensorPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "sensor", sender: self)
    }
    
    
    @IBAction func lightPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "light", sender: self)
    }
    
    @IBAction func pngPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "png", sender: self)
    }
    @IBAction func bangPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "bang", sender: self)
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: self)
    }
    
    @IBAction func chatStartPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginPage", sender: self)
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
