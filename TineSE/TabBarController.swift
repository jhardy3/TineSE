//
//  TabBarController.swift
//  TineSE
//
//  Created by Jake Hardy on 4/4/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var profileCurrentlySelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in self.tabBar.items! {
            item.image = item.selectedImage?.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            //In case you wish to change the font color as well
            let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            item.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.selectedImage == UIImage(named: "Profile") && !profileCurrentlySelected {
            profileCurrentlySelected = true
            NSNotificationCenter.defaultCenter().postNotificationName("ProfileTriggered", object: nil)
        } else if item.selectedImage != UIImage(named: "Profile") {
            profileCurrentlySelected = false
        }
    }

}

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
