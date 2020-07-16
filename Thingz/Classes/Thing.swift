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

class Thing {
    var id: UUID
    var name: String
    var description: String
    var barcode: String
    var photos: [UIImage]
    
    init(id: UUID = UUID(), name: String, description: String = "", barcode: String = "", photos: [UIImage] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.barcode = barcode
        self.photos = photos
    }
    
    func save(file: DatabaseFile) -> Int64? {
        do {
            let things = Table("Things")
            let id = Expression<String>("id")
            let name = Expression<String>("name")
            let description = Expression<String>("description")
            let barcode = Expression<String>("barcode")
            
            try file.db?.run(things.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(description)
                t.column(barcode)
            })
            
            let insert = things.insert(id <- self.id.uuidString, name <- self.name, description <- self.description, barcode <- self.barcode)
            let rowid = try file.db?.run(insert)
            return rowid
        } catch {
            debugPrint("Error saving location!")
            return nil
        }
    }
}
