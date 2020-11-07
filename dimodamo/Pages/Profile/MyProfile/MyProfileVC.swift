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
    @IBOutlet weak var bubblePopup: UIImageView!
    @IBOutlet weak var menuBtn: UIButton! {
        didSet {
            
        }
    }
    
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
            for tag in tags {
                tag.layer.borderWidth = 1.5
                tag.layer.borderColor = UIColor.appColor(.system).cgColor
                tag.layer.cornerRadius = tag.frame.height / 2
                tag.layer.masksToBounds = true
                
                tag.widthAnchor.constraint(equalToConstant: 73).isActive = true
                tag.textAlignment = .center
                tag.attributedText = NSAttributedString.init(string: "안녕", attributes: [NSAttributedString.Key.baselineOffset : -1])
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        animate()
        
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }
        
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
        }, completion: nil)
    }
    
    private func setColors() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.yellowDark)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        print("클릭")
        performSegue(withIdentifier: "ArchiveVC", sender: nil)
        //        performSegue(withIdentifier: "ArchiveVC", sender: nil)
    }
    
    /*
     Dpti 버튼을 눌렀을 경우
     */
    @IBAction func pressedDptiBtn(_ sender: Any) {
        performSegue(withIdentifier: "MyDptiVC", sender: sender)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch segue.identifier {
        case "MyDptiVC":
            let destinationVC = destination
            break
            
        case "ArchiveVC":
            break
            
        default:
            break
        }
    }
    
}
