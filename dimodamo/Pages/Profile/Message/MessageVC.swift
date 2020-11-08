//
//  MessageVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    @IBOutlet weak var manitoBtn: UIButton! {
        didSet {
            manitoBtn.layer.cornerRadius = manitoBtn.frame.height / 2
            manitoBtn.layer.borderWidth = 1.5
            
            // 상대방 쪽지 컬러로 변경할 것
            manitoBtn.layer.borderColor = UIColor.appColor(.pinkDark).cgColor
        }
    }
    
    /*
     ViewLoad
     */
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.white255)
        
        // 해당 유저 컬러로 변경할 것
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.pinkDark)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appColor(.textBig)]
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
