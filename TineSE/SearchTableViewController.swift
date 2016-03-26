//
//  SearchTableViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/21/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Properties
    
    var searchController: UISearchController!
    var usersDataSource = [Hunter]()
    
    // View Mode Enum Dictates which content will be displayed based on segmented controller
    enum ViewMode: Int {
        
        // Hunters case displayed tracked hunters
        case Hunters = 0
        
        // Displays all Hunters narrowed by search term
        case AddHunter = 1
        
        // function retrieves hunters based on mode
        func hunters(completion:(hunters: [Hunter]) -> Void) {
            
            // Function switches on self checking for view mode and carring out approriate function accordingly
            switch self {
                
            // Hunter case fetches all hunters with current hunters trackingID's array and completes with those hunters
            case Hunters:
                guard let tracking = HunterController.sharedInstance.currentHunter?.trackingIDs else { completion(hunters: []) ; return }
                HunterController.fetchHuntersWithIdentifierArray(tracking, completion: { (hunters) -> Void in
                    completion(hunters: hunters)
                })
                
            // Add Hunter case fetches all hunters
            case AddHunter:
                HunterController.fetchAllHunters({ (var hunters) -> Void in
                    
                    // Declare index of removal to remove self from list
                    var indexOfRemoval: Int?
                    
                    // Loop through IDs until self is found and set index of removal
                    for index in 0..<hunters.count {
                        if HunterController.sharedInstance.currentHunter!.identifier! == hunters[index].identifier! {
                            indexOfRemoval = index
                        }
                    }
                    
                    // Remove self (always will run)
                    if let indexOfRemoval = indexOfRemoval {
                        hunters.removeAtIndex(indexOfRemoval)
                    }
                    
                    
                    // Complete with hunters Array
                    completion(hunters: hunters)
                })
            }
        }
    }
    
    // Gettable property that returns View Mode based on segmented control index
    var mode: ViewMode {
        get {
            return ViewMode(rawValue: segmentedControl.selectedSegmentIndex)!
        }
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Updates view based on view mode currently selected
        updateViewBasedOnMode()
        
        // Sets up the search controller class and search bar for searching searches
        setUpSearchController()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersDataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = usersDataSource[indexPath.row].username
        
        return cell
    }
    
    // MARK: - View Based Functions
    
    // Updates based on current View Mode
    func updateViewBasedOnMode() {
        
        // Calls viewmode respective hunter function and sets data source to accordingly return hunters array
        // Reloads tableview on main queue
        mode.hunters { (hunters) -> Void in
            self.usersDataSource = hunters
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // Sets up the search controller
    func setUpSearchController() {
        
        // Results controller is a disjoint TableView. Instantiate it!
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UserSearchResultsTableViewController")
        
        // Assign Search Controller property with instantiated search controller with results controller as searchResultsController
        // Assign delegate to self
        // Make search bar auto size to fit view
        // Dont hide nav bar
        // Assign search bar to top of tableview as header
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        // Not sure what this does
        definesPresentationContext = true
        
    }
    
    // Updates current search results
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // Grabs search term from seachController search bar lowercase ; grabs searchViewController
        if let searchTerm = searchController.searchBar.text?.lowercaseString,
            let resultsViewController = searchController.searchResultsController as? SearchResultsTableViewController {
                
                // Assign resultsView data sources as filtered array based on search term ; reload data
                resultsViewController.usersResultsDataSource = usersDataSource.filter {$0.username.lowercaseString.containsString(searchTerm)}
                resultsViewController.tableView.reloadData()
        }
        
    }
    
    // Updates view for segmented control change
    @IBAction func segmentedControllerChanged(sender: UISegmentedControl) {
        updateViewBasedOnMode()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toHunter" {
            guard let cell = sender as? UITableViewCell else { return }
            
            if let indexPath = tableView.indexPathForCell(cell) {
                
                guard let hunterID = usersDataSource[indexPath.row].identifier else { return }
                
                let destinationViewController = segue.destinationViewController as? ProfileViewController
                destinationViewController?.updateWithIdentifier(hunterID)
                
            } else if let indexPath = (searchController.searchResultsController as? SearchResultsTableViewController)?.tableView.indexPathForCell(cell) {
                
                guard let hunterID = (searchController.searchResultsController as! SearchResultsTableViewController).usersResultsDataSource[indexPath.row].identifier else { return }
                
                let destinationViewController = segue.destinationViewController as? ProfileViewController
                destinationViewController?.updateWithIdentifier(hunterID)
            }
        }
    }
    
    
}
