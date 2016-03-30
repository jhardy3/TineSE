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
    var sheds =  [Shed]()
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
    
    
    // is Following Bool checks for following status based on button title text
    var isFollowing: Bool {
        get {
            if followButton.titleLabel?.text == "Track" {
                return false
            } else {
                return true
            }
        }
    }
    
    // MARK: - Class Functions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if tabBarController?.selectedIndex == 3 && tabBarController?.selectedIndex != 4 {
            guard let currentHunterID = HunterController.sharedInstance.currentHunter?.identifier else { return }
            self.updateWithIdentifier(currentHunterID)
        }
        
        if viewLoaded == false {
            NSThread.sleepForTimeInterval(0.3)
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.hunter = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.followButton.layer.borderColor = UIColor.hunterOrange().CGColor
        self.followButton.layer.borderWidth = 1
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, kMargin, 0, kMargin)
        flowLayout.minimumLineSpacing = kMargin * 2
        flowLayout.minimumInteritemSpacing = 0
        
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
        
        // Guard for hunter
        guard let hunter = self.hunter else { return }
        
        
        if followButton.titleLabel?.text != "Log Out" {
            // Check if hunter is following ; if is following unfollow and set title Vice versa otherwise
            if isFollowing {
                HunterController.hunterUntrackHunter(hunter, completion: { (trackingCount) in
                    if let trackingCount = trackingCount {
                        self.followButton.setTitle("Track", forState: .Normal)
                        self.trackersCountLabel.text = String(trackingCount)
                    }
                })
            } else {
                HunterController.hunterTrackHunter(hunter)
                followButton.setTitle("Untrack", forState: .Normal)
                trackersCountLabel.text = String(hunter.trackingIDs.count)
                self.reloadInputViews()
            }
        } else {
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
                self.shedCountLabel.text = (String(hunter.shedCount))
                self.hunterProfileImage.layer.cornerRadius = 20.0
                self.hunterProfileImage.clipsToBounds = true
                print("Hunter Received")
            }
            dispatch_group_leave(groupNew)
        }
        
        dispatch_group_notify(groupNew, dispatch_get_main_queue()) { () -> Void in
            self.viewLoaded = true
            self.view.reloadInputViews()
            // Checks current hunter for profile hunter ID. If exists sets title to untrack otherwise sets to track
            if let hunterTrackIDs = HunterController.sharedInstance.currentHunter?.trackingIDs, let hunterID = self.hunter?.identifier {
                if hunterTrackIDs.contains(hunterID) {
                    self.followButton.setTitle("Untrack", forState: .Normal)
                } else {
                    self.followButton.setTitle("Track", forState: .Normal)
                }
                
                // If viewing own profile, sets follow button to hidden
                if HunterController.sharedInstance.currentHunter?.identifier == hunterID {
                    self.followButton.setTitle("Log Out", forState: .Normal)
                }
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
                self.sheds.sortInPlace { $0.0.identifier > $0.1.identifier }
                self.collectionView.reloadData()
            }
        }
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
