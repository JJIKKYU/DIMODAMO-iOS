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
        
//        searchBar.setTextField(color: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1))
//        searchBar.getTextField()?.addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16.0, opacity: 0.12)
//        searchBar.getTextField()?.borderStyle = .none
//        searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchBarBackgroundWhite"), for: .normal)
        
        
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

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
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
