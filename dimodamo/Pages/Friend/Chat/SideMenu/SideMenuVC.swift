//
//  SideMenuVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import Malert

class SideMenuVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = UIColor.appColor(.white255)
            backgroundView.layer.cornerRadius = 16
            backgroundView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var exitView: ExitAlertView! {
        didSet {
//            exitView = ExitAlertView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedExitBtn(_ sender: Any) {
//        let alertVC = AlertController(title: "타이틀", message: "메세지입니다", preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "나가기", style: .default, handler: nil))
//
//        self.present(alertVC, animated: true, completion: nil)
        
//        let exitAlertView = ExitAlertView()
        
        let exampleView: ExitAlertView = UIView.fromNib()
        print(exampleView)
        
//        let malert = Malert(customView: exampleView)
//        let malert = Malert(title: "하이", customView: view, tapToDismiss: true, dismissOnActionTapped: true)
//        let action = MalertAction(title: "나가기")
//        action.backgroundColor = UIColor.appColor(.system)
//        action.tintColor = UIColor.appColor(.white255)
//
//        malert.addAction(action)
//        malert.animationType = .fadeIn
//        malert.presentDuration = 1
//
//        present(malert, animated: true, completion: nil)
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

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}



