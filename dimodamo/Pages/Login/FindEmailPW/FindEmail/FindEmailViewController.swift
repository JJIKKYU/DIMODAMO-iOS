//
//  FindEmailViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class FindEmailViewController: UIViewController {
    
    @IBOutlet weak var findBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        

    }
    
    // 터치했을때 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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


extension FindEmailViewController {
    func viewDesign() {
        findBtn.layer.cornerRadius = 16
    }
    
}
