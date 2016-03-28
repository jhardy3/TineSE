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
    
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var shedImageView: UIImageView!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var shedTypeTextLabel: UILabel!
    @IBOutlet weak var shedColorTextLabel: UILabel!
    
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
        
        //         self.contentView.backgroundColor = UIColor.desertSkyBlue()
        
        // If shed image exists, set shedImageView to image
        if shed.shedImage == nil {
            shedImageView.image = UIImage(named: "Sheds")
            shedImageView.downloadImageFrom(link: shed.imageIdentifier, contentMode: UIViewContentMode.ScaleAspectFit)
            shed.shedImage = shedImageView.image
            delegate?.tableView.reloadData()
        } else {
            shedImageView.image = shed.shedImage
        }
        
        
        // Set usernameTextField text to passed in shed username
        self.shedColorTextLabel.text = "SHED COLOR: \(shed.shedColor.uppercaseString)"
        self.shedTypeTextLabel.text = "Shed Type: \(shed.shedType)"
        self.usernameTextField.text = shed.username
        
    }
    
    @IBAction func utilitiesButtonTapped(sender: UIButton) {
        
    }

}

extension UIImageView {
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

