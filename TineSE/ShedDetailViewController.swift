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
    @IBOutlet weak var animalImageView: UIImageView!
    
    var shed: Shed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shedColorLabel.textColor = UIColor.hunterOrange()
        shedTypeLabel.textColor = UIColor.hunterOrange()
        if let shed = self.shed {
            updateWithShed(shed)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWithShed(shed: Shed) {

        self.navigationController?.navigationBar.topItem?.title = shed.username
        self.shedImageView.image = shed.shedImage
        self.shedTypeLabel.text = "Shed Type: \(shed.shedType)"
        self.shedColorLabel.text = "Shed Color: \(shed.shedColor)"
        
        switch shed.shedType {
            case "Moose":
                animalImageView.image = UIImage(named: "Moose")
            case "Elk":
                animalImageView.image = UIImage(named: "Elk")
            case "Deer":
                animalImageView.image = UIImage(named: "Deer")
        default:
                animalImageView.image = UIImage(named: "llama")
        }
        
        if shed.shedColor == "Non-Shed" {
            self.shedTypeLabel.text = "...not all sheds can be found..."
            self.shedColorLabel.hidden = true
            animalImageView.image = UIImage(named: "llama")
        }
        
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
