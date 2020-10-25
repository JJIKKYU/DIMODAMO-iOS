//
//  CreatePostViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var descriptionContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

// MARK: - UI Design

extension CreatePostViewController {
    func viewDesign() {
        self.descriptionContainer.layer.borderWidth = 1.5
        self.descriptionContainer.layer.borderColor = UIColor.appColor(.white245).cgColor
        self.descriptionContainer.layer.cornerRadius = 9
        self.descriptionContainer.layer.masksToBounds = true
    }
}
