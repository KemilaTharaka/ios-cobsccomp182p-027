//
//  Constants.swift
//  NIBM EVENTS-AKT DE SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/26/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
}

struct AppColors {
    static let Blue = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
    static let DarkBlue = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    static let White = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let EventCell = "EventCell"
}

struct Segues {
    static let ToEvents = "toEventsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditEvent = "ToAddEditEvent"
}
