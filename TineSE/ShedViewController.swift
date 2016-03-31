//
//  ShedViewController.swift
//  TineSE
//
//  Created by Jake Hardy on 3/30/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class ShedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shedImageView: UIImageView!
    
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  comments.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.hunterIdentifier
        
        return cell
    }
    
    
    func updateWithShed(shed: Shed) {
        guard let shedImage = shed.shedImage else { return }
        self.shedImageView.image = shedImage
    }
    

}
