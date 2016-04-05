//
//  LoadViewController.swift
//  TineSE
//
//  Created by Jake Hardy on 4/5/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {

    static let sharedLoad = LoadViewController()
    
    @IBOutlet weak var scopeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAnimation()
//        blurImageBackground(self.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
