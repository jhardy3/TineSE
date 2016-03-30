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
    var sheds = [Hunter]()
    var filterdSheds = [Hunter]()
    var isTracking = false
    
    override func viewWillAppear(animated: Bool) {
        fetchAllHuntersForLeaderBoard()
        fetchTrackedHuntersForLeaderBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTracking == false {
            return sheds.count
        } else {
            return filterdSheds.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leaderboardCell", forIndexPath: indexPath)
        if isTracking == false {
            cell.textLabel?.text = sheds[indexPath.row].username
            cell.detailTextLabel?.text = String(sheds[indexPath.row].shedCount)
        } else {
            cell.textLabel?.text = filterdSheds[indexPath.row].username
            cell.detailTextLabel?.text = String(filterdSheds[indexPath.row].shedCount)
        }
        
        return cell
    }
    
    func fetchTrackedHuntersForLeaderBoard() {
        guard var currentHunterIDs = HunterController.sharedInstance.currentHunter?.trackingIDs else { return }
        currentHunterIDs.append(HunterController.sharedInstance.currentHunter!.identifier!)
        HunterController.fetchHuntersWithIdentifierArray(currentHunterIDs) { (hunters) -> Void in
            self.filterdSheds = hunters.sort { $0.shedCount > $1.shedCount }
        }
    }
    
    func fetchAllHuntersForLeaderBoard() {
        HunterController.fetchAllHunters { (hunters) -> Void in
            self.sheds = hunters.sort { $0.shedCount > $1.shedCount }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        isTracking = !isTracking
        self.tableView.reloadData()
    }
    
}
