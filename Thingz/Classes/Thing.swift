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
let COLUMN_THING_BARCODE = Expression<String>("barcode")
let COLUMN_THING_LOCID = Expression<String>("location_id")

class Thing {
    var id: UUID
    var name: String
    var description: String
    var barcode: String
    var locationId: UUID
    var photos: [UIImage]
    
    init(id: UUID = UUID(), name: String, description: String = "", barcode: String = "", locationId: UUID, photos: [UIImage] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.barcode = barcode
        self.locationId = locationId
        self.photos = photos
    }
    
    func save(file: DatabaseFile) -> Int64? {
        do {
            try file.db?.run(TABLE_THINGS.create(ifNotExists: true) { t in
                t.column(COLUMN_THING_ID, primaryKey: true)
                t.column(COLUMN_THING_NAME)
                t.column(COLUMN_THING_DESC)
                t.column(COLUMN_THING_BARCODE)
                t.column(COLUMN_THING_LOCID)
            })
            
            let insert = TABLE_THINGS.insert(COLUMN_THING_ID <- self.id.uuidString, COLUMN_THING_NAME <- self.name, COLUMN_THING_DESC <- self.description, COLUMN_THING_BARCODE <- self.barcode, COLUMN_THING_LOCID <- self.locationId.uuidString)
            let rowid = try file.db?.run(insert)
            return rowid
        } catch {
            debugPrint("Error saving location!")
            return nil
        }
    }
}
