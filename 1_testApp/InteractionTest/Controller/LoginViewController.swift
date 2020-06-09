//
//  LoginViewController.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/06/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
   
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "loginToChat", sender: self)
                }
              // ...
            }
        }
    }
}
