//
//  DptiResultViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/11.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DptiResultViewController: UIViewController {

    @IBOutlet weak var resultCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultCardViewInit()
        
    }

    func resultCardViewInit() {
        resultCardView.layer.cornerRadius = 24
        resultCardView.addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
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

