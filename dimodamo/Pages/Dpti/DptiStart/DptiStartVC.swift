//
//  DptiStartVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/28.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DptiStartVC: UIViewController {

    @IBOutlet weak var textViewContainer: UIView! {
        didSet {
            textViewContainer.layer.cornerRadius = 16
            textViewContainer.layer.masksToBounds = true
            textViewContainer.appShadow(.s12)
            textViewContainer.backgroundColor = UIColor.appColor(.white255)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedStartBtn(_ sender: Any) {
        performSegue(withIdentifier: "DptiSurveyVC", sender: nil)
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
