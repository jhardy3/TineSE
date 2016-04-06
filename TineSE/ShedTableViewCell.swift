//
//  ShedTableViewCell.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class ShedTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    var delegate: TinelineViewController?
    var shed: Shed?
    
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var shedImageView: UIImageView!
    
    @IBOutlet weak var reportButton: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
    // MARK: - UI Updating Functions
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.shedImageView.image = nil
    }
    
    // Update View with passed in shed
    func updateWith(shed: Shed) {
        self.shed = shed
        self.usernameTextField.textColor = UIColor.hunterOrange()
        
        // If shed image exists, set shedImageView to image
        if shed.shedImage == nil {
            shedImageView.image = UIImage(named: "Skull")
            shedImageView.downloadImageFrom(link: shed.imageIdentifier, contentMode: UIViewContentMode.ScaleAspectFit)
            shed.shedImage = shedImageView.image
        } else {
            shedImageView.image = shed.shedImage
        }
        
        self.reportButton.layer.opacity = 0.3
        
        // Set usernameTextField text to passed in shed username
        self.usernameTextField.text = shed.username.lowercaseString
    }
    
    @IBAction func utilitiesButtonTapped(sender: UIButton) {
        guard let shedID = shed?.identifier else { return }
        let alertController = UIAlertController(title: "REPORT FOR:", message: "", preferredStyle: .ActionSheet)
        let inappropriateAlert = UIAlertAction(title: "Inappropriate Content", style: .Default) { (alert) -> Void in
            FirebaseController.firebase.childByAppendingPath("/inappropriateContent/\(shedID)").setValue(true)
        }
        let misleadingContentAlert = UIAlertAction(title: "False Information", style: .Default) { (alert) -> Void in
            FirebaseController.firebase.childByAppendingPath("/mislabeled/\(shedID)").setValue(true)
        }
        
        if let shed = self.shed, let currentHunterID = HunterController.sharedInstance.currentHunter?.identifier
            where currentHunterID == self.shed?.hunterIdentifier {
            let deleteContentAlert = UIAlertAction(title: "Delete", style: .Destructive, handler: { (alert) in
                ShedController.deleteShed(shed)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard let index = self.delegate?.tableView.indexPathForCell(self)?.row else { return }
                    self.delegate?.trackingSheds.removeAtIndex(index)
                    self.delegate?.tableView.reloadData()
                    NSNotificationCenter.defaultCenter().postNotificationName("shedDeleted", object: nil)
                })
                
            })
            alertController.addAction(deleteContentAlert)
        }
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        alertController.addAction(inappropriateAlert)
        alertController.addAction(misleadingContentAlert)
        alertController.addAction(cancelAlert)
        
        delegate?.presentViewController(alertController, animated: true, completion: nil)
    }
    
}


