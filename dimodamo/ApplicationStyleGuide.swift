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
    
    case green1
    case green2
    case green3
    
    case red
}

extension UIImage {
    // 프로필에 쓰이는 타입 아이콘
    static func dptiProfileTypeIcon(_ type: String, isFiiled: Bool) -> UIImage {
        let iconType = isFiiled == true ? "Fill" : "Stroke"
        
        let colorTypeCharacter = type[type.index(type.startIndex, offsetBy: 2)]
        var colorString: String = ""
        
        switch colorTypeCharacter {
        // DPTI 결과에 따른 컬러
        case "F":
            colorString = "Pink"
            break
        case "P":
            colorString = "Yellow"
            break
        case "T":
            colorString = "Blue"
            break
        case "J":
            colorString = "Purple"
            break
        default:
            colorString = ""
            break
        }
        
        
        let shapeTypeCharacter = type[type.index(type.startIndex, offsetBy: 3)]
        var shapeString: String = ""
        
        switch shapeTypeCharacter {
        // DPTI 결과에 따른 컬러
        case "I":
            shapeString = "Star"
            break
        case "N":
            shapeString = "Triangle"
            break
        case "S":
            shapeString = "Square"
            break
        case "E":
            shapeString = "Circle"
            break
        default:
            shapeString = ""
            break
        }
        
        return UIImage(named: "Type_Icon_\(iconType)_\(shapeString)_\(colorString)")!
    }
    
    static func shapeBackgroundPattern(_ type: String) -> UIImage {
        let shapeTypeCharacter = type[type.index(type.startIndex, offsetBy: 3)]
        var shapeString: String = ""
        
        switch shapeTypeCharacter {
        // DPTI 결과에 따른 컬러
        case "I":
            shapeString = "Star"
            break
        case "N":
            shapeString = "Triangle"
            break
        case "S":
            shapeString = "Square"
            break
        case "E":
            shapeString = "Circle"
            break
        default:
            shapeString = ""
            break
        }
        
        return UIImage(named: "Background_Pattern_\(shapeString)")!
    }
}

extension UIColor {
    static func dptiColor(_ type: String) -> UIColor {
        let type = type[type.index(type.startIndex, offsetBy: 2)]
        
        switch type {
        // DPTI 결과에 따른 컬러
        case "F":
            return #colorLiteral(red: 0.9803921569, green: 0.6274509804, blue: 0.7058823529, alpha: 1)
        case "P":
            return #colorLiteral(red: 0.9803921569, green: 0.8235294118, blue: 0.431372549, alpha: 1)
        case "T":
            return #colorLiteral(red: 0.4705882353, green: 0.8431372549, blue: 0.8823529412, alpha: 1)
        case "J":
            return #colorLiteral(red: 0.4705882353, green: 0.5882352941, blue: 1, alpha: 1)
        default:
            return #colorLiteral(red: 1, green: 0.568627451, blue: 0.3529411765, alpha: 1)
        }
    }
    
    static func dptiDarkColor(_ type: String) -> UIColor {
        let type = type[type.index(type.startIndex, offsetBy: 2)]
        
        switch type {
        // DPTI 결과에 따른 컬러
        case "F":
            return #colorLiteral(red: 0.9803921569, green: 0.4901960784, blue: 0.6078431373, alpha: 1)
        case "P":
            return #colorLiteral(red: 0.9803921569, green: 0.7450980392, blue: 0.2549019608, alpha: 1)
        case "T":
            return #colorLiteral(red: 0.1960784314, green: 0.7647058824, blue: 0.8431372549, alpha: 1)
        case "J":
            return #colorLiteral(red: 0.3529411765, green: 0.4901960784, blue: 0.9607843137, alpha: 1)
        default:
            return #colorLiteral(red: 1, green: 0.568627451, blue: 0.3529411765, alpha: 1)
        }
    }
    
  static func appColor(_ name: AssetsColor) -> UIColor {
    switch name {
    // Purple
    case .purple:
        return #colorLiteral(red: 0.4705882353, green: 0.5882352941, blue: 1, alpha: 1)
    case .purpleDark:
        return #colorLiteral(red: 0.3529411765, green: 0.4901960784, blue: 0.9607843137, alpha: 1)
    case .purpleLight:
        return #colorLiteral(red: 0.8235294118, green: 0.862745098, blue: 1, alpha: 1)
    
    // Blue
    case .blue:
        return #colorLiteral(red: 0.4705882353, green: 0.8431372549, blue: 0.8823529412, alpha: 1)
    case .blueDark:
        return #colorLiteral(red: 0.1960784314, green: 0.7647058824, blue: 0.8431372549, alpha: 1)
    case .blueLight:
        return #colorLiteral(red: 0.7450980392, green: 0.9803921569, blue: 1, alpha: 1)
        
    // Pink
    case .pink:
        return #colorLiteral(red: 0.9803921569, green: 0.6274509804, blue: 0.7058823529, alpha: 1)
    case .pinkDark:
        return #colorLiteral(red: 0.9803921569, green: 0.4901960784, blue: 0.6078431373, alpha: 1)
    case .pinkLight:
        return #colorLiteral(red: 1, green: 0.862745098, blue: 0.9019607843, alpha: 1)
        
    // Yellow
    case .yellow:
        return #colorLiteral(red: 0.9803921569, green: 0.8235294118, blue: 0.431372549, alpha: 1)
    case .yellowDark:
        return #colorLiteral(red: 0.9803921569, green: 0.7450980392, blue: 0.2549019608, alpha: 1)
    case .yellowLight:
        return #colorLiteral(red: 1, green: 0.9411764706, blue: 0.7843137255, alpha: 1)
        
    // system
    case .system:
        return #colorLiteral(red: 1, green: 0.568627451, blue: 0.3529411765, alpha: 1)
    case .systemActive:
        return #colorLiteral(red: 1, green: 0.5294117647, blue: 0.2156862745, alpha: 1)
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
        
    // Green
    case .green1:
        return #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.3254901961, alpha: 1)
    case .green2:
        return #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1)
    case .green3:
        return #colorLiteral(red: 0.4352941176, green: 0.8117647059, blue: 0.5921568627, alpha: 1)
        
    // Red EB5757
    case .red:
        return #colorLiteral(red: 0.9215686275, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
    }
  }
}


//MARK: - AddShadow.swift, 그림자 스타일가이드

enum AssetsShadow {
    case s4
    case s8
    case s12
    case s16
    case s20
}

extension UIView {
    func appShadow(_ shadow: AssetsShadow) {
        
        let offset: CGSize = CGSize(width: 0, height: 4)
        let color: UIColor = UIColor.black
        let radius: CGFloat = 16
        var opacity: Float?
        
        
        switch shadow{
        case .s4:
            opacity = 0.04
            break
        case .s8:
            opacity = 0.08
            break
        case .s12:
            opacity = 0.12
            break
        case .s16:
            opacity = 0.16
            break
        case .s20:
            opacity = 0.20
            break
            
        
        }
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity!
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
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


//MARK: - Image JPEG Reduce Quality

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func resize(withWidth newWidth: CGFloat) -> UIImage? {

        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

// MARK: - Hide/Show LargeTitle TextAttribute

extension UINavigationController {
    func invisible() {
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
    }
    
    func visible(color: UIColor) {
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
}


//class MyStyles: NSObject {
//  static func fontForStyle(style:String)->UIFont{
//    switch style{
//    case "p":
//        return UIFont.systemFont(ofSize: 18);
//    case "h1":
//        return UIFont.boldSystemFont(ofSize: 36);
//    case "h2":
//        return UIFont.boldSystemFont(ofSize: 24);
//    default:
//        return MyStyles.fontForStyle(style: "p");
//    }
//  }
//}
//
//@IBDesignable class MyLabel: UILabel {
//  @IBInspectable var style:String="p"{
//    didSet{self.font=MyStyles.fontForStyle(style: style)}
//  }
//}
