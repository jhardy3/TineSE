//
//  TinelineViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit
import CoreLocation



class TinelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    // Create a sheds array to hold sheds being displayed by tableview cells
    var sheds = [Shed]()
    var LocalSheds = [Shed]()
    var shedIDs = [String]()
    
    // Crates a gettable bool which is dependent upon the
    // segmented control
    var currentViewIsLocal: Bool {
        get {
            switch segmentedController.selectedSegmentIndex {
            case 0:
                return false
            default:
                return true
            }
        }
    }
    
    // holds a locationManager that will be used to access 
    // current user location
    var locationManager: CLLocationManager!
    
    // MARK: - IBOutlet Properties
    
    // Segmented Controller that swaps between hunter tineline and proximity tineline
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setup location manger and request current location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        if let location = locationManager.location {
            print("have location")
            let circleQuery = LocationController.geoFire.queryAtLocation(location, withRadius: 80.0)
            circleQuery.observeEventType(.KeyEntered, withBlock: { (string, location) -> Void in
                if !self.shedIDs.contains(string) {
                    self.shedIDs.append(string)
                    ShedController.fetchShed(string, completion: { (shed) -> Void in
                        self.LocalSheds.append(shed!)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if self.currentViewIsLocal {
                                self.LocalSheds.sortInPlace { $0.0.identifier > $0.1.identifier}
                                self.tableView.reloadData()
                            }
                        })
                    })
                }
            })
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newShedsAddedRefresh", name: "shedAdded", object: nil)
        
        // Fetch all sheds for initial tineline preview ( eventually this will be dependent upon segmented control && refined )
                ShedController.fetchShedsForTineline { (sheds) -> Void in
        
                    // Call main queue to refresh view; reload tableview data accordingly
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.sheds = sheds.sort { $0.0.identifier > $0.1.identifier }
                        self.tableView.reloadData()
                    })
                }
        
        
        // Adds a refreshController. Grabs new Tineline information when present
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shedCell", forIndexPath: indexPath) as! ShedTableViewCell
        
        if currentViewIsLocal {
            cell.updateWith(LocalSheds[indexPath.row])
        } else {
            cell.updateWith(sheds[indexPath.row])
        }
        
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentViewIsLocal {
            return LocalSheds.count
        } else {
            return sheds.count
        }
    }
    
    // MARK: - Data Update Functions
    
    func refresh(refreshControl: UIRefreshControl) {
        
        // When refreshed, completes fetch sheds again and reloads tableview in main thread
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        ShedController.fetchShedsForTineline { (shedsReturned) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.sheds = shedsReturned.sort { $0.0.identifier > $0.1.identifier }
                
                dispatch_group_leave(group)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
            })
        }
        
        // End refresh animation
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            NSThread.sleepForTimeInterval(1)
            refreshControl.endRefreshing()
        }
        
    }
    
    func newShedsAddedRefresh() {
        // When refreshed, completes fetch sheds again and reloads tableview in main thread
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        ShedController.fetchShedsForTineline { (shedsReturned) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.sheds = shedsReturned.sort { $0.0.identifier > $0.1.identifier }
                
                
                
                dispatch_group_leave(group)
            })
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        self.tableView.reloadData()
        self.LocalSheds.sortInPlace { $0.0.identifier > $0.1.identifier }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProfile" {
            
            // Grab destination view controller
            let destinationView = segue.destinationViewController as? ProfileViewController
            
            // Button is inside of tableView cell. It is the sender in this case so cast it as UIButton
            if let button = sender as? UIButton,
                
                // button.superview returns the ShedTableViewCell view instance (this is what we want, it will grab the indexPath)
                let view = button.superview,
                
                // the superview of the view instance is the actual shedTableViewCell
                let cell = view.superview as? ShedTableViewCell {
                    
                    // If all succeeds grab index path from tableview using cell or return
                    guard let indexPath = tableView.indexPathForCell(cell)  else { return }
                    
                    // grab identifier from sheds at indexpath and update destinationView with identifier
                    if !currentViewIsLocal {
                        let identifier = self.sheds[indexPath.row].hunterIdentifier
                        destinationView?.updateWithIdentifier(identifier)
                    } else {
                        let identifier = self.LocalSheds[indexPath.row].hunterIdentifier
                        destinationView?.updateWithIdentifier(identifier)
                    }
                    
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
    }
}
