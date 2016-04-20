//
//  Restaurant.swift
//  Ambrosia
//
//  Created by Brett Meehan on 3/20/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//
import CoreLocation


class Restaurant: NSObject, NSCoding {
    // MARK: Properties
    
    let name: String
    let googleMapsID: String
    let latitude: Double
    let longitude: Double
    var categories: [NSIndexPath]
    var lastVisit: NSDate?
    var numVisits: Int
    var notes: String
    var rating: NSIndexPath
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("restaurants")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let googleMapsIDKey = "googleMapsID"
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let categoriesKey = "categories"
        static let lastVisitKey = "lastVisit"
        static let numVisitsKey = "numVisits"
        static let notesKey = "notes"
        static let ratingKey = "rating"
    }
    
    // MARK: Initialization
    
    init?(name: String, ID: String, latitude: Double, longitude: Double, categories: [NSIndexPath], lastVisit: NSDate?, numVisits: Int, notes: String?, rating: NSIndexPath) {
        // Initialize stored properties.
        self.name = name
        self.googleMapsID = ID
        self.latitude = latitude
        self.longitude = longitude
        self.categories = categories
        self.lastVisit = lastVisit
        self.numVisits = numVisits
        self.notes = notes ?? ""
        self.rating = rating
        
        super.init()
        
        // Initialization should fail if there is no name.
        if name.isEmpty || ID.isEmpty || categories.count < 1 || numVisits < 0 {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(googleMapsID, forKey: PropertyKey.googleMapsIDKey)
        aCoder.encodeDouble(latitude, forKey: PropertyKey.latitudeKey)
        aCoder.encodeDouble(longitude, forKey: PropertyKey.longitudeKey)
        aCoder.encodeObject(categories, forKey: PropertyKey.categoriesKey)
        aCoder.encodeObject(lastVisit, forKey: PropertyKey.lastVisitKey)
        aCoder.encodeInteger(numVisits, forKey: PropertyKey.numVisitsKey)
        aCoder.encodeObject(notes, forKey: PropertyKey.notesKey)
        aCoder.encodeObject(rating, forKey: PropertyKey.ratingKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let googleMapsID = aDecoder.decodeObjectForKey(PropertyKey.googleMapsIDKey) as! String
        let latitude = aDecoder.decodeDoubleForKey(PropertyKey.latitudeKey)
        let longitude = aDecoder.decodeDoubleForKey(PropertyKey.longitudeKey)
        let categories = aDecoder.decodeObjectForKey(PropertyKey.categoriesKey) as! [NSIndexPath]
        let lastVisit = aDecoder.decodeObjectForKey(PropertyKey.lastVisitKey) as? NSDate
        let numVisits = aDecoder.decodeIntegerForKey(PropertyKey.numVisitsKey)
        let notes = aDecoder.decodeObjectForKey(PropertyKey.notesKey) as! String
        let rating = aDecoder.decodeObjectForKey(PropertyKey.ratingKey) as! NSIndexPath
        
        self.init(name: name, ID: googleMapsID, latitude: latitude, longitude: longitude, categories: categories, lastVisit: lastVisit, numVisits: numVisits, notes: notes, rating: rating)
    }
}

