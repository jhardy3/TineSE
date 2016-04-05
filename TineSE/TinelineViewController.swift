//
//  TinelineViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit
import CoreLocation


enum ShedViewMode {
    case Local
    case Tracking
}


class TinelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    // Create a sheds array to hold sheds being displayed by tableview cells
    var trackingSheds = [Shed]()
    var LocalSheds = [Shed]()
    var localShedIDs = [String]()
    var shedIDs = [String]()
    
    var currentView: ShedViewMode {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            return .Tracking
        default:
            return.Local
        }
    }
    
    var dataSource: [Shed] {
        switch currentView {
        case .Local:
            return LocalSheds
        case .Tracking:
            return trackingSheds
        }
    }
    
    var endOfTableView = false {
        didSet {
            if endOfTableView == true {
                self.grabSheds()
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
        
        setupLocationManagerAndGrabLocalSheds()
        fetchShedsFirstLoad()
        setUpRefreshController()
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        checkForEndOfTableview(indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("shedCell", forIndexPath: indexPath) as! ShedTableViewCell
        
        cell.updateWith(dataSource[indexPath.row])
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // MARK: - Data Update Functions / Shed acquisition functions
    
    func updateTableViewWithShed(shed: Shed) {
        if currentView == .Tracking {
            self.trackingSheds.append(shed)
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.trackingSheds.count - 1, inSection: 0)], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
        }
    }
    
    func checkForEndOfTableview(indexPath: NSIndexPath) {
        if indexPath.row == trackingSheds.count - 1 && currentView == .Tracking {
            self.endOfTableView = true
        } else {
            self.endOfTableView = false
        }
    }
    
    func grabSheds() {
        
        var tempShedIDs = [String]()
        if self.shedIDs.count > 5 {
            tempShedIDs = createArray(self.shedIDs, range: 5)
        } else {
            tempShedIDs = createArray(self.shedIDs, range: self.shedIDs.count)
        }
        var tempSheds = [Shed]()
        
        let group = dispatch_group_create()
        
        for ID in tempShedIDs {
            dispatch_group_enter(group)
            ShedController.fetchShed(ID, completion: { (shed) in
                if let shed = shed {
                    tempSheds.append(shed)
                }
                dispatch_group_leave(group)
            })
            
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            tempSheds.sortInPlace { $0.0.identifier > $0.1.identifier }
            for shed in tempSheds {
                self.updateTableViewWithShed(shed)
            }
        }
        
    }
    
    func createArray(array: [String], range: Int) -> [String] {
        var returnArray = [String]()
        var indexOfRemoval: Int?
        
        for number in 0..<range {
            indexOfRemoval = number
            returnArray.append(array[number])
            print("index of removal = \(indexOfRemoval)")
        }
        
        if let indexOfRemoval = indexOfRemoval {
            for _ in 0...indexOfRemoval {
                self.shedIDs.removeAtIndex(0)
                print("\(self.shedIDs.count) shed ID count")
            }
        }
        
        return returnArray
    }
    
    func fetchShedsFirstLoad() {
        // Fetch all sheds for initial tineline preview ( eventually this will be dependent upon segmented control && refined )
        ShedController.fetchShedIDsForTineline { (sheds) in
            self.shedIDs = sheds.sort { $0 > $1 }
            self.grabSheds()
        }
    }
    
    // MARK: - Refresh Functions
    
    func refresh(refreshControl: UIRefreshControl) {
        
        if currentView == .Local {
            refreshControl.endRefreshing()
        } else {
            self.trackingSheds = []
            ShedController.fetchShedIDsForTineline { (sheds) in
                self.shedIDs = sheds.sort { $0 > $1 }
                self.grabSheds()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                })
                
            }
        }
    }
    
    func setUpRefreshController() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TinelineViewController.newShedsAddedRefresh), name: "shedAdded", object: nil)
        
        // Adds a refreshController. Grabs new Tineline information when present
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TinelineViewController.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func newShedsAddedRefresh() {
        // When refreshed, completes fetch sheds again and reloads tableview in main thread
        self.trackingSheds = []
        ShedController.fetchShedIDsForTineline { (sheds) in
            self.shedIDs = sheds.sort { $0 > $1 }
            self.tableView.reloadData()
            self.grabSheds()
        }
        
    }
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
                
        self.tableView.reloadData()
        self.LocalSheds.sortInPlace { $0.0.identifier > $0.1.identifier }
    }

    
    // MARK: - Location Functions
    
    func setupLocationManagerAndGrabLocalSheds() {
        
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
                if !self.localShedIDs.contains(string) {
                    self.localShedIDs.append(string)
                    ShedController.fetchShed(string, completion: { (shed) -> Void in
                        self.LocalSheds.append(shed!)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if self.currentView == .Local {
                                self.LocalSheds.sortInPlace { $0.0.identifier > $0.1.identifier}
                                self.tableView.reloadData()
                            }
                        })
                    })
                }
            })
            
            circleQuery.observeEventType(.KeyExited, withBlock: { (string, location) in
                if self.localShedIDs.contains(string) {
                    var indexOfRemoval: Int?
                    for index in 0..<self.LocalSheds.count {
                        if self.LocalSheds[index].identifier == string {
                            indexOfRemoval = index
                        }
                    }
                    if let indexOfRemoval = indexOfRemoval {
                        self.LocalSheds.removeAtIndex(indexOfRemoval)
                        self.tableView.reloadData()
                    }
                    
                }
            })

        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
    }
    
    // MARK: Segue
    
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
                
                let identifier = self.dataSource[indexPath.row].hunterIdentifier
                destinationView?.updateWithIdentifier(identifier)
                
            }
        }
    }
    
}
