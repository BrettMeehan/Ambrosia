//
//  RestaurantEditViewController.swift
//  Ambrosia
//
//  Created by Brett Meehan on 3/18/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit
import GoogleMaps

class RestaurantEditViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var numVisitsLabel: UITextField!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var reviewOptionsTable: UITableView!
    @IBOutlet weak var pickPlaceButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var notesButton: UIButton!
    
    
    var restaurantDict = [String: Restaurant]()
    var restaurant: Restaurant?
    var placeName: String?
    var placeID: String?
    var placeLatitude: Double?
    var placeLongitude: Double?
    var lastVisit: NSDate?
    var numVisits = 0
    var notes: String?
    
    let locationManager = CLLocationManager()
    var updatedLocation = false
    
    let dateFormatter = NSDateFormatter()
    
    var categoryTableDelegate: MultipleCategoryTableViewDelegate?
    var reviewOptionsTableDelegate: ReviewOptionsTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        categoryTableDelegate = MultipleCategoryTableViewDelegate(parentViewController: self)
        reviewOptionsTableDelegate = ReviewOptionsTableViewDelegate(parentViewController: self)
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        dateLabel.delegate = self
        numVisitsLabel.delegate = self
        
        categoryTable.allowsMultipleSelection = true
        categoryTable.delegate = categoryTableDelegate
        categoryTable.dataSource = categoryTableDelegate

        reviewOptionsTable.delegate = reviewOptionsTableDelegate
        reviewOptionsTable.dataSource = reviewOptionsTableDelegate
        
        if restaurant != nil{//load restaurant
            placeName = restaurant!.name
            placeID = restaurant!.googleMapsID
            placeLatitude = restaurant!.latitude
            placeLongitude = restaurant!.longitude
            lastVisit = restaurant!.lastVisit
            numVisits = restaurant!.numVisits
            notes = restaurant!.notes
            
            setRestaurantLabel()
            pickPlaceButton.setTitle("Edit Location", forState: .Normal)
            updateNotesButton()
            
            if lastVisit != nil{
                dateLabel.text = dateFormatter.stringFromDate(lastVisit!)
            }
            
            numVisitsLabel.text = String(numVisits)
            
            for indexPath in restaurant!.categories{
                categoryTable.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                categoryTableDelegate!.tableView(categoryTable, didSelectRowAtIndexPath: indexPath)
            }
            
            reviewOptionsTable.selectRowAtIndexPath(restaurant!.rating, animated: false, scrollPosition: .None)
            reviewOptionsTableDelegate!.tableView(reviewOptionsTable, didSelectRowAtIndexPath: restaurant!.rating)
        }else{
            saveButton.enabled = false
        }
    }
    
    func setRestaurantLabel(){
        if placeName!.characters.count > 20{
            restaurantLabel.text = "Editing: " + placeName!.substringToIndex(placeName!.startIndex.advancedBy(20)) + "..."
        } else{
            restaurantLabel.text = "Editing: " + placeName!
        }
    }
    
    func updateNotesButton(){
        if notes != ""{
            notesButton.setTitle("Edit Notes", forState: .Normal)
        }else{
            notesButton.setTitle("Add Notes", forState: .Normal)
        }
    }
    
    func checkSaveEligibility(){
        let categorySelected = categoryTable.indexPathsForSelectedRows != nil
        let ratingSelected = reviewOptionsTable.indexPathForSelectedRow != nil
        
        if placeName != nil && placeID != nil && placeLatitude != nil && placeLongitude != nil && categorySelected && ratingSelected {
            saveButton.enabled = true
        }else{
            saveButton.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField === dateLabel{
            let userDate = dateFormatter.dateFromString(textField.text!)
            let today = NSDate()
            
            if userDate != nil && (today.compare(userDate!) == .OrderedSame || today.compare(userDate!) == .OrderedDescending){
                lastVisit = userDate
            }else{
                dateLabel.text = dateFormatter.stringFromDate(lastVisit ?? today)
            }
        } else if textField === numVisitsLabel{
            let userNumVisits = Int(numVisitsLabel.text!)
            if userNumVisits != nil && userNumVisits! >= 0{
                numVisits = userNumVisits!
            }else{
                numVisitsLabel.text = String(numVisits)
            }
        }
    }
    
    @IBAction func addVisit(sender: UIButton) {
        lastVisit = NSDate()
        dateLabel.text = dateFormatter.stringFromDate(lastVisit!)
        numVisits += 1
        numVisitsLabel.text = String(numVisits)
    }
    
    @IBAction func pickPlace(sender: UIButton) {
        updatedLocation = false //update location each time user presses "Add/edit location" button
        locationManager.requestLocation()
    }
    
    // MARK: -CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("updated locations")
        if updatedLocation{
            return
        }else{
            updatedLocation = true
            manager.stopUpdatingLocation()
        }
        
        let currentCoordinates = manager.location?.coordinate
        if currentCoordinates == nil{
            print("failed")
        }else{
            let center = currentCoordinates!
            let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
            let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
            let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            let config = GMSPlacePickerConfig(viewport: viewport)
            let placePicker = GMSPlacePicker(config: config)
            
            placePicker.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
                if let error = error {
                    print("Pick Place error: \(error.localizedDescription)")
                    return
                }
                
                if let chosenPlace = place {
                    print("Place name \(chosenPlace.name)")
                    print("Place address \(chosenPlace.formattedAddress)")
                    print("Place attributions \(chosenPlace.attributions)")
                    
                    self.placeName = chosenPlace.name
                    self.placeID = chosenPlace.placeID
                    self.placeLatitude = chosenPlace.coordinate.latitude
                    self.placeLongitude = chosenPlace.coordinate.longitude
                    
                    self.setRestaurantLabel()
                    self.pickPlaceButton.setTitle("Edit Location", forState: .Normal)
                    self.checkSaveEligibility()
                    
                } else {
                    print("No place selected")
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("failed with error \(error.code)")
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender === saveButton{
            let selectedCategories = categoryTable.indexPathsForSelectedRows!
            
            let selectedRatingRow = reviewOptionsTable.indexPathForSelectedRow!
            
            self.restaurant = Restaurant(name: placeName!, ID: placeID!, latitude: placeLatitude!, longitude: placeLongitude!, categories: selectedCategories, lastVisit: lastVisit, numVisits: numVisits, notes: notes, rating: selectedRatingRow)
            if let rest = self.restaurant{
                if let savedRestaurants = loadRestaurants(){
                    restaurantDict = savedRestaurants
                }
                
                restaurantDict[placeID!] = rest
                print("this: " + rest.notes)
                saveRestaurants()
            }
            print("Saving to storage: ")
        }else if sender === notesButton{
            let notesController = segue.destinationViewController as! NotesViewController
            notesController.notes = notes
            notesController.revc = self
            print("revc notes: " + (notes ?? ""))
        }
        print("end of prepare for segue")
    }
    
    
    // MARK: NSCoding
    
    func saveRestaurants(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(restaurantDict, toFile: Restaurant.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save restaurant...")
        }
    }
    
    func loadRestaurants() -> [String: Restaurant]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Restaurant.ArchiveURL.path!) as? [String: Restaurant]
    }

}
