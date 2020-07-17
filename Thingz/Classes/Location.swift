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

class Location {
    var id: UUID
    var name: String
    var description: String
    var photos: [UIImage]
    
    init(id: UUID = UUID(), name: String, description: String = "", photos: [UIImage] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.photos = photos
    }
    
    func save(file: DatabaseFile) -> Int64? {
        do {
            try file.db?.run(TABLE_LOCATIONS.create(ifNotExists: true) { t in
                t.column(COLUMN_LOCATION_ID, primaryKey: true)
                t.column(COLUMN_LOCATION_NAME, unique: true)
                t.column(COLUMN_LOCATION_DESC)
            })
            
            let insert = TABLE_LOCATIONS.insert(COLUMN_LOCATION_ID <- self.id.uuidString, COLUMN_LOCATION_NAME <- self.name, COLUMN_LOCATION_DESC <- self.description)
            let rowid = try file.db?.run(insert)
            return rowid
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
                        let loadedLocation = Location(id: loadedId, name: location[COLUMN_LOCATION_NAME], description: location[COLUMN_LOCATION_DESC])
                        loadedLocations.append(loadedLocation)
                    }
                }
            } catch {
                debugPrint("No locations found")
            }
        }
        return loadedLocations
    }
}
