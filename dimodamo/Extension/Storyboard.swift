//
//  Storyboard.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryBoard{
   class func load(_ storyboard: String) -> UIViewController{
      return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: storyboard)
   }
}
