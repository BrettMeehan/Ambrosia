//
//  ReviewOptionsTableViewDelegate.swift
//  Ambrosia
//
//  Created by Brett Meehan on 4/3/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit

class ReviewOptionsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    struct ReviewOptionsProperties{
        static let reviewOptionsData = ["Yes", "No", "Never been here"]
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
        // #warning Incomplete implementation, return the number of rows
        return ReviewOptionsProperties.reviewOptionsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ReviewOptionsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ReviewOptionsTableViewCell
        
        // Configure the cell...
        cell.reviewLabel.text = ReviewOptionsProperties.reviewOptionsData[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        parentViewController.checkSaveEligibility()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
}