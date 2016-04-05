//
//  AppearanceController.swift
//  Tine
//
//  Created by Jake Hardy on 3/24/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import Foundation
import UIKit

class AppearanceController {
    
    static func initializaeAppearanceDefaults() {
        
        UINavigationBar.appearance().barTintColor = UIColor.hunterOrange()
        UIToolbar.appearance().barTintColor = UIColor.hunterOrange()
        UISegmentedControl.appearance().tintColor = UIColor.whiteColor()
        UISegmentedControl.appearance()
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor.hunterOrange()
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState: .Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Application)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
         UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
    }
    
    
}