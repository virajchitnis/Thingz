//
//  Thing.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/16/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import Foundation
import UIKit
import SQLite

let TABLE_THINGS = Table("Things")
let COLUMN_THING_ID = Expression<String>("id")
let COLUMN_THING_NAME = Expression<String>("name")
let COLUMN_THING_DESC = Expression<String>("description")
let COLUMN_THING_QUANT = Expression<Int64>("quantity")
let COLUMN_THING_BARCODE = Expression<String>("barcode")
let COLUMN_THING_LOCID = Expression<String>("location_id")

class Thing {
    var id: UUID
    var name: String
    var description: String
    var quantity: Int
    var barcode: String
    var locationId: UUID
    var photos: [UIImage]
    
    init(id: UUID = UUID(), name: String, description: String = "", quantity: Int = 1, barcode: String = "", locationId: UUID, photos: [UIImage] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.quantity = quantity
        self.barcode = barcode
        self.locationId = locationId
        self.photos = photos
    }
    
    func save(to file: DatabaseFile, completionHandler: @escaping (Int64?, Error?) -> Void) {
        fileQueue.async {
            do {
                try file.db?.run(TABLE_THINGS.create(ifNotExists: true) { t in
                    t.column(COLUMN_THING_ID, primaryKey: true)
                    t.column(COLUMN_THING_NAME)
                    t.column(COLUMN_THING_DESC)
                    t.column(COLUMN_THING_QUANT)
                    t.column(COLUMN_THING_BARCODE)
                    t.column(COLUMN_THING_LOCID)
                })
                
                let insert = TABLE_THINGS.insert(COLUMN_THING_ID <- self.id.uuidString, COLUMN_THING_NAME <- self.name, COLUMN_THING_DESC <- self.description, COLUMN_THING_QUANT <- Int64(self.quantity), COLUMN_THING_BARCODE <- self.barcode, COLUMN_THING_LOCID <- self.locationId.uuidString)
                let rowid = try file.db?.run(insert)
                
                var success = true
                for photo in self.photos {
                    if photo.save(to: file, withOwner: self.id) == nil {
                        success = false
                    }
                }
                
                if success {
                    DispatchQueue.main.async {
                        completionHandler(rowid, nil)
                    }
                }
            } catch {
                print("Unexpected error: \(error).")
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func update(in file: DatabaseFile, completionHandler: @escaping (Error?) -> Void) {
        fileQueue.async {
            let thisThing = TABLE_THINGS.filter(COLUMN_THING_ID == self.id.uuidString)
            do {
                try file.db?.run(thisThing.update(COLUMN_THING_NAME <- self.name, COLUMN_THING_DESC <- self.description, COLUMN_THING_QUANT <- Int64(self.quantity), COLUMN_THING_BARCODE <- self.barcode))
                
                UIImage.delete(for: self.id, from: file)
                for photo in self.photos {
                    photo.save(to: file, withOwner: self.id)
                }
                
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
    }
    
    class func delete(thing: Thing, from file: DatabaseFile) -> Bool {
        let thisThing = TABLE_THINGS.filter(COLUMN_THING_ID == thing.id.uuidString)
        do {
            try file.db?.run(thisThing.delete())
            
            var success = true
            if !UIImage.delete(for: thing.id, from: file) {
                success = false
            }
            
            if !success {
                return false
            }
            return true
        } catch {
            debugPrint("Error deleting thing!")
            return false
        }
    }
}
