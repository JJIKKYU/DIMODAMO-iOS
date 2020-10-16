//
//  CommunityMain.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import UIKit

// SegueName
struct CommunitySegueName {
    static let article: String = "ArticleVC"
    static let information: String = "InformationVC"
}

struct CellHeight {
    static let articleHeight: Int = 437
    static let informationHeight: Int = 140
}

/// WARNING: Change these constants according to your project's design
struct NavigationBarConst {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 18
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 18
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}
