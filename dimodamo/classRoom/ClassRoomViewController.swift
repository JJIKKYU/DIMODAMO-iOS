//
//  ClassRoomViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/10.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ClassRoomViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.setTextField(color: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1))
    
        
//        searchBar.getTextField()?.layer.shadowOffset = .zero
//        searchBar.getTextField()?.layer.masksToBounds = true
//        searchBar.getTextField()?.layer.shadowRadius = 5
//        searchBar.getTextField()?.layer.shadowColor = UIColor.black.cgColor
        
        searchBar.getTextField()?.layer.masksToBounds = false
        searchBar.getTextField()?.layer.shadowRadius = 5.0
        searchBar.getTextField()?.layer.shadowColor = UIColor.black.cgColor
        searchBar.getTextField()?.layer.shadowOffset = CGSize(width: 1, height: 1.3)
        searchBar.getTextField()?.layer.shadowOpacity = 0.12
        

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

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
