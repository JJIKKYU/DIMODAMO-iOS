//
//  ApplicationStyleGuide.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/18.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import UIKit


enum AssetsColor {
    case purple
    case purpleDark
    case purpleLight
    
    case blue
    case blueDark
    case blueLight
    
    case pink
    case pinkDark
    case pinkLight
    
    case yellow
    case yellowDark
    case yellowLight
    
    case system
    case systemActive
    case systemUnactive
    
    case textBig
    case textSmall
    
    case gray170
    case gray190
    case gray210
    
    case white235
    case white245
    case white255
}


extension UIColor {
  static func appColor(_ name: AssetsColor) -> UIColor {
    switch name {
    // Purple
    case .purple:
        return #colorLiteral(red: 0.4117647059, green: 0.568627451, blue: 1, alpha: 1)
    case .purpleDark:
        return #colorLiteral(red: 0.2941176471, green: 0.4901960784, blue: 0.9019607843, alpha: 1)
    case .purpleLight:
        return #colorLiteral(red: 0.8235294118, green: 0.862745098, blue: 1, alpha: 1)
    
    // Blue
    case .blue:
        return #colorLiteral(red: 0.2156862745, green: 0.8235294118, blue: 0.862745098, alpha: 1)
    case .blueDark:
        return #colorLiteral(red: 0.2156862745, green: 0.7647058824, blue: 0.8235294118, alpha: 1)
    case .blueLight:
        return #colorLiteral(red: 0.7450980392, green: 0.9803921569, blue: 1, alpha: 1)
        
    // Pink
    case .pink:
        return #colorLiteral(red: 1, green: 0.4509803922, blue: 0.5882352941, alpha: 1)
    case .pinkDark:
        return #colorLiteral(red: 0.9607843137, green: 0.3333333333, blue: 0.5490196078, alpha: 1)
    case .pinkLight:
        return #colorLiteral(red: 1, green: 0.862745098, blue: 0.9019607843, alpha: 1)
        
    // Yellow
    case .yellow:
        return #colorLiteral(red: 1, green: 0.8235294118, blue: 0.3921568627, alpha: 1)
    case .yellowDark:
        return #colorLiteral(red: 1, green: 0.7254901961, blue: 0.1764705882, alpha: 1)
    case .yellowLight:
        return #colorLiteral(red: 1, green: 0.9411764706, blue: 0.7843137255, alpha: 1)
        
    // system
    case .system:
        return #colorLiteral(red: 1, green: 0.5490196078, blue: 0.2941176471, alpha: 1)
    case .systemActive:
        return #colorLiteral(red: 1, green: 0.431372549, blue: 0.03921568627, alpha: 1)
    case .systemUnactive:
        return #colorLiteral(red: 1, green: 0.8235294118, blue: 0.6666666667, alpha: 1)
        
    // Text
    case .textBig:
        return #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
    case .textSmall:
        return #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
        
    // Gray
    case .gray170:
        return #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    case .gray190:
        return #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)
    case .gray210:
        return #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
    
    // White
    case .white235:
        return #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    case .white245:
        return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    case .white255:
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
  }
}


extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}



//MARK: - AppStyleGuide

class AppStyleGuide {
    static func systemBtnRadius16(btn : UIButton, isActive: Bool) {
        let btnColor: UIColor = isActive == true ? UIColor.appColor(.systemActive) : UIColor.appColor(.gray210)
        
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 16
    }
    
    static func navigationBarWhite(navController: UINavigationController) {
        let navBar = navController.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
    }
    
    static func navBarOrange(navigationController: UINavigationController) {
        navigationController.navigationBar.tintColor = UIColor.appColor(.system)
    }
}


//MARK: - UILABEL Kerning

extension UILabel {

    @IBInspectable var kerning: Float {
        get {
            var range = NSMakeRange(0, (text ?? "").count)
            guard let kern = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: &range),
                let value = kern as? NSNumber
                else {
                    return 0
            }
            return value.floatValue
        }
        set {
            var attText:NSMutableAttributedString

            if let attributedText = attributedText {
                attText = NSMutableAttributedString(attributedString: attributedText)
            } else if let text = text {
                attText = NSMutableAttributedString(string: text)
            } else {
                attText = NSMutableAttributedString(string: "")
            }

            let range = NSMakeRange(0, attText.length)
            attText.addAttribute(NSAttributedString.Key.kern, value: NSNumber(value: newValue), range: range)
            self.attributedText = attText
        }
    }
}
