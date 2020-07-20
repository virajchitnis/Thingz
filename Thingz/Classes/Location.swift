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
    
    func save(to file: DatabaseFile, completionHandler: @escaping (Int64?, Error?) -> Void) {
        fileQueue.async {
            UIImage.save(photos: self.photos, withOwner: self.id, to: file, completionHandler: { error in
                if error == nil {
                    do {
                        try file.db?.run(TABLE_LOCATIONS.create(ifNotExists: true) { t in
                            t.column(COLUMN_LOCATION_ID, primaryKey: true)
                            t.column(COLUMN_LOCATION_NAME)
                            t.column(COLUMN_LOCATION_DESC)
                            t.column(COLUMN_LOCATION_BARCODE)
                        })
                        
                        let insert = TABLE_LOCATIONS.insert(COLUMN_LOCATION_ID <- self.id.uuidString, COLUMN_LOCATION_NAME <- self.name, COLUMN_LOCATION_DESC <- self.description, COLUMN_LOCATION_BARCODE <- self.barcode)
                        let rowid = try file.db?.run(insert)
                        
                        DispatchQueue.main.async {
                            completionHandler(rowid, nil)
                        }
                    } catch {
                        print("Unexpected error: \(error).")
                        DispatchQueue.main.async {
                            completionHandler(nil, error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            })
        }
    }
    
    class func read(from file: DatabaseFile, completionHandler: @escaping ([Location], Error?) -> Void) {
        fileQueue.async {
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
                    DispatchQueue.main.async {
                        completionHandler(loadedLocations, nil)
                    }
                } catch let Result.error(_, code, _) where code == 1 {
                    DispatchQueue.main.async {
                        completionHandler(loadedLocations, nil)
                    }
                } catch {
                    print("Unexpected error: \(error).")
                    DispatchQueue.main.async {
                        completionHandler(loadedLocations, error)
                    }
                }
            }
        }
    }
    
    func loadAllThings(from file: DatabaseFile) {
        var loadedThings: [Thing] = []
        if let db = file.db {
            do {
                for thing in try db.prepare(TABLE_THINGS.filter(COLUMN_THING_LOCID == self.id.uuidString)) {
                    if let loadedId = UUID(uuidString: thing[COLUMN_THING_ID]) {
                        let loadedThing = Thing(id: loadedId, name: thing[COLUMN_THING_NAME], description: thing[COLUMN_THING_DESC], quantity: Int(thing[COLUMN_THING_QUANT]), barcode: thing[COLUMN_THING_BARCODE], locationId: self.id)
                        loadedThing.photos = UIImage.loadAllPhotos(for: loadedThing.id, from: file)
                        loadedThings.append(loadedThing)
                    }
                }
            } catch {
                print("Unexpected error: \(error).")
            }
        }
        self.things = loadedThings
    }
    
    func update(in file: DatabaseFile, completionHandler: @escaping (Error?) -> Void) {
        fileQueue.async {
            UIImage.delete(for: self.id, from: file, completionHandler: { error in
                if error == nil {
                    UIImage.save(photos: self.photos, withOwner: self.id, to: file, completionHandler: { error in
                        if error == nil {
                            let thisLocation = TABLE_LOCATIONS.filter(COLUMN_LOCATION_ID == self.id.uuidString)
                            if let db = file.db {
                                do {
                                    try db.run(thisLocation.update(COLUMN_LOCATION_NAME <- self.name, COLUMN_LOCATION_DESC <- self.description, COLUMN_LOCATION_BARCODE <- self.barcode))
                                    DispatchQueue.main.async {
                                        completionHandler(nil)
                                    }
                                } catch {
                                    print("Unexpected error: \(error).")
                                    DispatchQueue.main.async {
                                        completionHandler(error)
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                completionHandler(error)
                            }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            })
        }
    }
    
    class func delete(location: Location, from file: DatabaseFile, completionHandler: @escaping (Error?) -> Void) {
        fileQueue.async {
            Thing.delete(things: location.things, for: location, from: file, completionHandler: { error in
                if error == nil {
                    UIImage.delete(for: location.id, from: file, completionHandler: { error in
                        if error == nil {
                            let thisLocation = TABLE_LOCATIONS.filter(COLUMN_LOCATION_ID == location.id.uuidString)
                            if let db = file.db {
                                do {
                                    try db.run(thisLocation.delete())
                                    DispatchQueue.main.async {
                                        completionHandler(nil)
                                    }
                                } catch {
                                    print("Unexpected error: \(error).")
                                    DispatchQueue.main.async {
                                        completionHandler(error)
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                completionHandler(error)
                            }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            })
        }
    }
}
