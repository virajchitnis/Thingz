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
            let locations = Table("Locations")
            let id = Expression<String>("id")
            let name = Expression<String>("name")
            let description = Expression<String>("description")
            
            try file.db?.run(locations.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name, unique: true)
                t.column(description)
            })
            
            let insert = locations.insert(id <- self.id.uuidString, name <- self.name, description <- self.description)
            let rowid = try file.db?.run(insert)
            return rowid
        } catch {
            debugPrint("Error saving location!")
            return nil
        }
    }
    
    class func loadFromDatabase(file: DatabaseFile) -> [Location] {
        let locations = Table("Locations")
        let id = Expression<String>("id")
        let name = Expression<String>("name")
        let description = Expression<String>("description")
        
        var loadedLocations: [Location] = []
        if let db = file.db {
            do {
                for location in try db.prepare(locations) {
                    if let loadedId = UUID(uuidString: location[id]) {
                        let loadedLocation = Location(id: loadedId, name: location[name], description: location[description])
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
