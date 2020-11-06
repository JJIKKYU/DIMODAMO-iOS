//
//  ProfileArchiveVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ProfileArchiveVC: UIViewController {

    /*
     TopContainer
     */
    @IBOutlet weak var heartcontainer: UIView! {
        didSet {
            heartcontainer.backgroundColor = UIColor.white
            heartcontainer.layer.borderWidth = 1.7
            heartcontainer.layer.borderColor = UIColor.appColor(.system).cgColor
            heartcontainer.layer.cornerRadius = heartcontainer.frame.height / 2
            heartcontainer.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var heartCountLabel: UILabel!
    
    @IBOutlet weak var dimoLayerBtn: UIButton!
    @IBOutlet weak var dimoArtboardBtn: UIButton!
    @IBOutlet weak var classRoomBtn: UIButton!
    @IBOutlet weak var underBar: UIView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.presentTransparentNavigationBar()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
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
