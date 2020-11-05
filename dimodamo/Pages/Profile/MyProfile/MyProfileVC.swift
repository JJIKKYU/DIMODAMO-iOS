//
//  MyProfileVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

enum MyProfileMoreBtn: Int {
    case like = 0
    case scrap = 1
    case heart = 2
}

class MyProfileVC: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    /*
     ProfileContainer
     */
    @IBOutlet weak var profileBG: UIView! {
        didSet {
            profileBG.layer.cornerRadius = profileBG.frame.height / 2
            profileBG.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var type: UIImageView!
    @IBOutlet weak var registerDate: UILabel!
    
    /*
     Tags
     */
    @IBOutlet var tags: [UILabel]! {
        didSet {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hideTransparentNavigationBar()
        navItem.backBarButtonItem?.tintColor = UIColor.white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.appColor(.gray190)
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
     활동 내역에서 모두 보기 눌렀을 경우
     */
    
    @IBAction func pressedMoreBtn(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        
        switch btn.tag {
        case MyProfileMoreBtn.like.rawValue:
            break
            
        case MyProfileMoreBtn.scrap.rawValue:
            break
            
        case MyProfileMoreBtn.heart.rawValue:
            break
            
        default:
            break
        }
        
        performSegue(withIdentifier: "ArchiveVC", sender: nil)
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
