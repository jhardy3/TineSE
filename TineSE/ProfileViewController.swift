//
//  ProfileViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/21/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit


enum FollowingState {
    case Following
    case NotFollowing
    case User
}

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Class Properties
    
    // Hunter for profile View
    var hunter: Hunter?
    var sheds =  [Shed]() {
        didSet {
            sheds.sortInPlace { $0.0.identifier > $0.1.identifier }
        }
    }
    let kMargin = CGFloat(1.0)
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var hunterProfileImage: UIImageView!
    
    @IBOutlet weak var brownsCountLabel: UILabel!
    @IBOutlet weak var whitesCountLabel: UILabel!
    @IBOutlet weak var chalksCountLabel: UILabel!
    
    @IBOutlet weak var trackersCountLabel: UILabel!
    @IBOutlet weak var shedCountLabel: UILabel!
    @IBOutlet weak var trackingCountLabel: UILabel!
    
    var viewLoaded = false
    var viewMode = FollowingState.User
    var trackingCount = 0
    
    
    // is Following Bool checks for following status based on button title text
    
    
    // MARK: - Class Functions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Updates with current hunter because (s)he is viewing own profile
        
        if tabBarController!.selectedIndex == 4 {
            guard let currentHunterID = HunterController.sharedInstance.currentHunter?.identifier else { return }
            self.updateWithIdentifier(currentHunterID)
        }
        
        if viewLoaded == false {
            NSThread.sleepForTimeInterval(0.3)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if viewMode != .User {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followButton.layer.cornerRadius = 7.0
        followButton.clipsToBounds = true
        self.followButton.layer.borderColor = UIColor.hunterOrange().CGColor
        self.followButton.layer.borderWidth = 1
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, kMargin, 0, kMargin)
        flowLayout.minimumLineSpacing = kMargin * 2
        flowLayout.minimumInteritemSpacing = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(shedDeletedUpdateView), name: "shedDeleted", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateWithHunter), name: "ProfileTriggered", object: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Collection View
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("shedCell", forIndexPath: indexPath) as? ImageCollectionViewCell {
            let shed = sheds[indexPath.row]
            cell.updateWith(shed)
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("shedCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sheds.count
    }
    
    // MARK: - IBAction Functions
    
    // Follows or unfollows a hunter depending on current follow status
    @IBAction func followButtonTapped(sender: UIButton) {
        guard let hunter = self.hunter else { return }
        
        switch viewMode {
        case .Following:
            
            self.trackingCount = self.trackingCount - 1
            self.trackersCountLabel.text = String(trackingCount)
            self.followButton.setTitle("Track", forState: .Normal)
            
            self.viewMode = .NotFollowing
            HunterController.hunterUntrackHunter(hunter)
            
        case .NotFollowing:
            
            self.trackingCount = self.trackingCount + 1
            self.trackersCountLabel.text = String(trackingCount)
            
            HunterController.hunterTrackHunter(hunter)
            followButton.setTitle("Untrack", forState: .Normal)
            
            self.viewMode = .Following
            
        case .User:
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
            HunterController.unauthHunter()
            
        }
        NSNotificationCenter.defaultCenter().postNotificationName("shedAdded", object: self)
    }
    
    
    // Update with identifier to retrieve hunter
    func updateWithIdentifier(identifier: String) {
        
        let groupNew = dispatch_group_create()
        
        dispatch_group_enter(groupNew)
        // Grab hunter from firebase
        HunterController.fetchHunterForIdentifier(identifier) { (hunter) -> Void in
            
            // If hunter is prevalent set hunter property to retrieved hunter
            if let hunter = hunter {
                self.hunter = hunter
                self.usernameLabel.text = hunter.username.lowercaseString
                self.brownsCountLabel.text = "Browns: " + (String(hunter.brownCount))
                self.whitesCountLabel.text = "Whites: " + (String(hunter.whiteCount))
                self.chalksCountLabel.text = "Chalks: " + (String(hunter.chalkCount))
                self.trackersCountLabel.text = (String(hunter.trackedIDs.count))
                self.trackingCountLabel.text = (String(hunter.trackingIDs.count))
                self.trackingCount = hunter.trackedIDs.count
                self.shedCountLabel.text = (String(hunter.shedCount))
                self.hunterProfileImage.layer.cornerRadius = 20.0
                self.hunterProfileImage.clipsToBounds = true
                print("Hunter Received")
            }
            dispatch_group_leave(groupNew)
        }
        
        dispatch_group_notify(groupNew, dispatch_get_main_queue()) { () -> Void in
            self.viewLoaded = true
            // Checks current hunter for profile hunter ID. If exists sets title to untrack otherwise sets to track
            guard let hunterTrackIDs = HunterController.sharedInstance.currentHunter?.trackingIDs, let hunterID = self.hunter?.identifier  else { return }
            
            if hunterTrackIDs.contains(hunterID) {
                self.followButton.setTitle("Untrack", forState: .Normal)
                self.viewMode = .Following
            } else if HunterController.sharedInstance.currentHunter?.identifier != hunterID  {
                self.followButton.setTitle("Track", forState: .Normal)
                self.viewMode = .NotFollowing
            } else {
                self.followButton.setTitle("Log Out", forState: .Normal)
                self.viewMode = .User
            }
            
            // Create group to keep async calls in order
            let group = dispatch_group_create()
            
            // check for hunter
            if let hunter = self.hunter {
                
                // If hunter exists grab all shed IDs and fetch shed ; enter dispatch group
                for id in hunter.shedIDs {
                    dispatch_group_enter(group)
                    
                    // Grab shed from firebase
                    ShedController.fetchShed(id, completion: { (shed) -> Void in
                        
                        // if shed is present append to sheds array
                        if let shed = shed {
                            self.sheds.append(shed)
                        }
                        
                        // notify dispatch call has ended
                        dispatch_group_leave(group)
                    })
                }
            }
            
            // Once async calls finish reload data
            dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
                self.collectionView.reloadData()
            }
        }
    }
    
    func shedDeletedUpdateView() {
        if let hunterID = self.hunter?.identifier {
            self.sheds = []
            self.collectionView.reloadData()
            self.updateWithIdentifier(hunterID)
        }
    }
    
    func updateWithHunter() {
        if let hunterID = HunterController.sharedInstance.currentHunter?.identifier {
            self.sheds = []
            self.updateWithIdentifier(hunterID)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let viewWidth = view.frame.width
        let viewWidthMinusMargin = viewWidth - kMargin * 6
        let itemDimension = viewWidthMinusMargin / 3.0
        
        return CGSizeMake(itemDimension, itemDimension)
    }
}
