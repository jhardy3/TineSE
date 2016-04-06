//
//  LeaderboardViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var hunters = [Hunter]()
    var filteredHunters = [Hunter]()
    var isTracking = false
    
    override func viewWillAppear(animated: Bool) {
        fetchAllHuntersForLeaderBoard()
        fetchTrackedHuntersForLeaderBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTracking == false {
            return hunters.count
        } else {
            return filteredHunters.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leaderboardCell", forIndexPath: indexPath)
        if isTracking == false {
            cell.textLabel?.textColor = UIColor.hunterOrange()
            cell.textLabel?.text = "\(indexPath.row + 1). \(hunters[indexPath.row].username)"
            cell.detailTextLabel?.text = String(hunters[indexPath.row].shedCount)
        } else {
            cell.textLabel?.text = filteredHunters[indexPath.row].username
            cell.detailTextLabel?.text = String(filteredHunters[indexPath.row].shedCount)
        }
        
        return cell
    }
    
    func fetchTrackedHuntersForLeaderBoard() {
        guard var currentHunterIDs = HunterController.sharedInstance.currentHunter?.trackingIDs else { return }
        currentHunterIDs.append(HunterController.sharedInstance.currentHunter!.identifier!)
        HunterController.fetchHuntersWithIdentifierArray(currentHunterIDs) { (hunters) -> Void in
            self.filteredHunters = hunters.sort { $0.shedCount > $1.shedCount }
        }
    }
    
    func fetchAllHuntersForLeaderBoard() {
        HunterController.fetchAllHunters { (hunters) -> Void in
            self.hunters = hunters.sort { $0.shedCount > $1.shedCount }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        isTracking = !isTracking
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toHunter" {
            let destinationView = segue.destinationViewController as? ProfileViewController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            if isTracking {
                guard let identifier = filteredHunters[index].identifier else { return }
                destinationView?.updateWithIdentifier(identifier)
            } else {
                guard let identifier = hunters[index].identifier else { return }
                destinationView?.updateWithIdentifier(identifier)
            }
        }
    }
}
