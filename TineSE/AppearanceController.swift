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
        
    }
    
    
}