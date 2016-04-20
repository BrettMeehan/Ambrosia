//
//  SearchResultsTableViewController.swift
//  Ambrosia
//
//  Created by Brett Meehan on 1/25/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit
import GoogleMaps

class SearchResultsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    struct SearchResultEntry{
        var name: String
        var placeID: String
    }
    
    // MARK: Properties
    let METERS_PER_MILE = 1609.344
    
    
    var searchName: String?
    var searchCategoryIndex: Int = 0
    var searchDistance: Double = 0.0
    var chooseNewRestaurant: Bool = false
    
    var searchResults = [SearchResultEntry]()
    var saveSearchResults: [SearchResultEntry]?
    var restaurantDict: [String: Restaurant]?
    var pickerIndex = 0
    var saveRestaurantDict = false
    
    let locationManager = CLLocationManager()
    var updatedLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        navigationItem.rightBarButtonItem = editButtonItem()

        loadSearchResults()
    }
    
    func loadSearchResults(){
        restaurantDict = loadRestaurants()
        let locationAuthStatus = CLLocationManager.authorizationStatus()
        if restaurantDict != nil && locationAuthStatus != CLAuthorizationStatus.Restricted && locationAuthStatus != CLAuthorizationStatus.Denied{
            locationManager.requestLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchResultsTableViewCell

        // Configure the cell...
        cell.restaurantNameLabel.text = searchResults[indexPath.row].name

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            restaurantDict!.removeValueForKey(searchResults[indexPath.row].placeID)
            saveRestaurantDict = true //save modified restaurant dict before segue
            if saveSearchResults != nil{
                saveSearchResults!.removeAtIndex((pickerIndex + saveSearchResults!.count - 1) % saveSearchResults!.count)// remove last picked restaurant
                print("\(saveSearchResults)")
            }
            searchResults.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    @IBAction func pickRestaurant(sender: UIButton) {
        if saveSearchResults == nil{
            saveSearchResults = searchResults
        }
        searchResults.removeAll()
        
        if saveSearchResults!.count > 0{
            var foundMatch = false
            for _ in 0...saveSearchResults!.count{
                print(saveSearchResults)
                print(saveSearchResults?.indices)
                print(pickerIndex % saveSearchResults!.count)
                let rest = restaurantDict![saveSearchResults![pickerIndex % saveSearchResults!.count].placeID]
                if rest!.rating.row != 1{ //not equal to "No"
                    searchResults.append(saveSearchResults![pickerIndex % saveSearchResults!.count])
                    self.tableView.reloadData()
                    foundMatch = true
                }
                pickerIndex += 1
                pickerIndex = pickerIndex % saveSearchResults!.count
                if foundMatch{
                    break
                }
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: -CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("updated locations")
        if updatedLocation{
            return
        }else{
            updatedLocation = true
            manager.stopUpdatingLocation()
        }
        for restaurant in restaurantDict!.values{
            let currentCoordinates = manager.location?.coordinate
            if currentCoordinates == nil{
                print("failed")
            }else{
                let distance = GMSGeometryDistance(currentCoordinates!, CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude))/METERS_PER_MILE
                print("\(distance)")
                
                var categoryIndexes = [Int]()
                for indexPath in restaurant.categories{
                    categoryIndexes.append(indexPath.row)
                }
                
                let testName = searchName! == "" ? true : restaurant.name.lowercaseString.rangeOfString(searchName!.lowercaseString) != nil
                let testCategory = categoryIndexes.indexOf(searchCategoryIndex) != nil
                let testDistance = distance <= searchDistance
                let testNewRestaurant = chooseNewRestaurant ? restaurant.rating.row == 2 : true //is equal to "Never been here"

                
                if testName && testCategory && testDistance && testNewRestaurant{
                    let entry = SearchResultEntry(name: restaurant.name, placeID: restaurant.googleMapsID)
                    searchResults.append(entry)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("failed with error \(error.code)")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveRestaurantDict{
            saveRestaurants()
            saveRestaurantDict = false
        }
        if segue.identifier == "ShowDetail" {
            let navController = segue.destinationViewController as! UINavigationController
            let restaurantEditController = navController.topViewController as! RestaurantEditViewController
            
            // Get the cell that generated this segue.
            if let selectedSearchResultCell = sender as? SearchResultsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSearchResultCell)!
                if let selectedRestaurant = restaurantDict![searchResults[indexPath.row].placeID]{
                    restaurantEditController.restaurant = selectedRestaurant}
                else{
                    print("super fail")
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController() && saveRestaurantDict{
            saveRestaurants()
            saveRestaurantDict = false
        }
    }
    
    
    // MARK: NSCoding
    
    func saveRestaurants(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(restaurantDict!, toFile: Restaurant.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save restaurant...")
        }
    }
    
    func loadRestaurants() -> [String: Restaurant]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Restaurant.ArchiveURL.path!) as? [String: Restaurant]
    }

}
