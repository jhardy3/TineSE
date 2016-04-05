//
//  ShedDetailViewController.swift
//  TineSE
//
//  Created by Jake Hardy on 4/5/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class ShedDetailViewController: UIViewController {
    
    @IBOutlet weak var shedImageView: UIImageView!
    @IBOutlet weak var shedColorLabel: UILabel!
    @IBOutlet weak var shedTypeLabel: UILabel!
    
    var shed: Shed?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let shed = shed {
            updateWithShed(shed)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWithShed(shed: Shed) {

        self.shedImageView.image = shed.shedImage
        self.shedTypeLabel.text = shed.shedType.capitalizedString
        self.shedColorLabel.text = shed.shedColor.capitalizedString

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
