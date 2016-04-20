//
//  BorderButton.swift
//  Ambrosia
//
//  Created by Brett Meehan on 1/9/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit

class BorderButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.layer.cornerRadius = 5.0;
        //self.layer.borderColor = UIColor.blueColor().CGColor
        //self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor(red: 0.05, green: 0, blue:0.8, alpha: 0.9)
        self.tintColor = UIColor.whiteColor()
        
    }

}
