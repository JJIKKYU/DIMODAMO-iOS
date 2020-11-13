//
//  ChatSideMenuNavigation.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import SideMenu

class ChatSideMenuNavigation: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationStyle = .menuSlideIn
        self.menuWidth = self.view.frame.width * 0.7
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
