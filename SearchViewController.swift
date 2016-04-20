//
//  SearchViewController.swift
//  Ambrosia
//
//  Created by Brett Meehan on 1/9/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var milesFromCurrentLocation: UITextField!
    @IBOutlet weak var chooseNewRestaurant: UISwitch!
    
    var searchDistance = 10.0
    
    let categoryPickerData = MultipleCategoryTableViewDelegate.CategoryProperties.categoryData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantName.delegate = self
        
        // Connect data:Picker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        milesFromCurrentLocation.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -picker view delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerData[row]
    }
    
    // MARK: UITextField delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField === milesFromCurrentLocation{
            let distance = Double(milesFromCurrentLocation.text!)
            if distance != nil && distance >= 0{
                searchDistance = distance!
            }else{
                milesFromCurrentLocation.text = ""
            }
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "GoToSearchResults" {
            //get a reference to the destination view controller
            let searchResultsController = segue.destinationViewController as! SearchResultsTableViewController
            
            searchResultsController.searchName = restaurantName.text
            searchResultsController.searchCategoryIndex = categoryPicker.selectedRowInComponent(0)
            searchResultsController.searchDistance = searchDistance
            searchResultsController.chooseNewRestaurant = chooseNewRestaurant.on
        }
     }
 
    
}
