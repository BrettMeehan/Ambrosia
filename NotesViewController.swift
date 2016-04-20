//
//  NotesViewController.swift
//  Ambrosia
//
//  Created by Brett Meehan on 4/8/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITextViewDelegate {

    // MARK: Properties
    
    var textView: UITextView?
    var notes: String?
    var revc: RestaurantEditViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView = UITextView(frame: view.bounds)
        textView!.font = UIFont(name: "Arial", size: 18)
        textView!.text = notes ?? ""
        view.addSubview(textView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController(){
            print("moving back")
            revc!.notes = textView!.text
            revc!.updateNotesButton()
            print("updated notes in revc controller")
        }
    }
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navController = segue.destinationViewController as! UINavigationController
        let restEditViewController = navController.topViewController as! RestaurantEditViewController
        restEditViewController.notes = textView!.text
        print("nc notes: " + (textView!.text ?? ""))
    }
 */

}
