//
//  MultipleCategoryTableViewDelegate.swift
//  Ambrosia
//
//  Created by Brett Meehan on 4/3/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit

class MultipleCategoryTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    struct CategoryProperties{
        static let categoryData = ["Breakfast", "Lunch", "Dinner", "Other"]
    }
    
    init(parentViewController: RestaurantEditViewController) {
        self.parentViewController = parentViewController
    }
    
    // MARK: Properties
    
    var parentViewController: RestaurantEditViewController
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return CategoryProperties.categoryData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CategoryTableViewCell
        
        // Configure the cell...
        cell.categoryLabel.text = CategoryProperties.categoryData[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        parentViewController.checkSaveEligibility()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        parentViewController.checkSaveEligibility()
    }
    
}