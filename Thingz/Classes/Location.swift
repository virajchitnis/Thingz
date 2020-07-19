//
//  Location.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/16/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import Foundation
import UIKit
import SQLite

let TABLE_LOCATIONS = Table("Locations")
let COLUMN_LOCATION_ID = Expression<String>("id")
let COLUMN_LOCATION_NAME = Expression<String>("name")
let COLUMN_LOCATION_DESC = Expression<String>("description")
let COLUMN_LOCATION_BARCODE = Expression<String>("barcode")

class Location: ObservableObject {
    var id: UUID
    var name: String
    var description: String
    var barcode: String
    @Published var things: [Thing]
    var photos: [UIImage]
    
    init(id: UUID = UUID(), name: String, description: String = "", barcode: String = "", things: [Thing] = [], photos: [UIImage] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.barcode = barcode
        self.things = things
        self.photos = photos
    }
    
    func save(file: DatabaseFile) -> Int64? {
        do {
            try file.db?.run(TABLE_LOCATIONS.create(ifNotExists: true) { t in
                t.column(COLUMN_LOCATION_ID, primaryKey: true)
                t.column(COLUMN_LOCATION_NAME, unique: true)
                t.column(COLUMN_LOCATION_DESC)
                t.column(COLUMN_LOCATION_BARCODE)
            })
            
            let insert = TABLE_LOCATIONS.insert(COLUMN_LOCATION_ID <- self.id.uuidString, COLUMN_LOCATION_NAME <- self.name, COLUMN_LOCATION_DESC <- self.description, COLUMN_LOCATION_BARCODE <- self.barcode)
            let rowid = try file.db?.run(insert)
            
            var success = true
            for photo in self.photos {
                if photo.save(to: file, withOwner: self.id) == nil {
                    success = false
                }
            }
            
            if success {
                return rowid
            }
            return nil
        } catch {
            debugPrint("Error saving location!")
            return nil
        }
    }
    
    class func loadFromDatabase(file: DatabaseFile) -> [Location] {
        var loadedLocations: [Location] = []
        if let db = file.db {
            do {
                for location in try db.prepare(TABLE_LOCATIONS) {
                    if let loadedId = UUID(uuidString: location[COLUMN_LOCATION_ID]) {
                        let loadedLocation = Location(id: loadedId, name: location[COLUMN_LOCATION_NAME], description: location[COLUMN_LOCATION_DESC], barcode: location[COLUMN_LOCATION_BARCODE])
                        loadedLocation.loadAllThings(from: file)
                        loadedLocation.photos = UIImage.loadAllPhotos(for: loadedLocation.id, from: file)
                        loadedLocations.append(loadedLocation)
                    }
                }
            } catch {
                debugPrint("No locations found")
            }
        }
        return loadedLocations
    }
    
    func loadAllThings(from file: DatabaseFile) {
        var loadedThings: [Thing] = []
        if let db = file.db {
            do {
                for thing in try db.prepare(TABLE_THINGS.filter(COLUMN_THING_LOCID == self.id.uuidString)) {
                    if let loadedId = UUID(uuidString: thing[COLUMN_THING_ID]) {
                        let loadedThing = Thing(id: loadedId, name: thing[COLUMN_THING_NAME], description: thing[COLUMN_THING_DESC], quantity: Int(thing[COLUMN_THING_QUANT]), barcode: thing[COLUMN_THING_BARCODE], locationId: self.id)
                        loadedThings.append(loadedThing)
                    }
                }
            } catch {
                debugPrint("No things found")
            }
        }
        self.things = loadedThings
    }
    
    func update(in file: DatabaseFile) -> Bool {
        let thisLocation = TABLE_LOCATIONS.filter(COLUMN_LOCATION_ID == self.id.uuidString)
        do {
            try file.db?.run(thisLocation.update(COLUMN_LOCATION_NAME <- self.name, COLUMN_LOCATION_DESC <- self.description, COLUMN_LOCATION_BARCODE <- self.barcode))
            return true
        } catch {
            debugPrint("Error updating location!")
            return false
        }
    }
    
    class func delete(location: Location, from file: DatabaseFile) -> Bool {
        let thisLocation = TABLE_LOCATIONS.filter(COLUMN_LOCATION_ID == location.id.uuidString)
        
        var success = true
        for thing in location.things {
            if !Thing.delete(thing: thing, from: file) {
                success = false
            }
        }
        
        if success {
            do {
                try file.db?.run(thisLocation.delete())
                return true
            } catch {
                debugPrint("Error deleting location!")
                return false
            }
        }
        return false
    }
}
