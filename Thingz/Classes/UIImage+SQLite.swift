//
//  UIImage+SQLite.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/19/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import Foundation
import UIKit
import SQLite

let TABLE_PHOTOS = Table("Photos")
let COLUMN_PHOTOS_DATA = Expression<String>("data")
let COLUMN_PHOTOS_OWNERID = Expression<String>("owner_id")

extension UIImage {
    func save(to file: DatabaseFile, withOwner owner: UUID) -> Int64? {
        do {
            try file.db?.run(TABLE_PHOTOS.create(ifNotExists: true) { t in
                t.column(COLUMN_PHOTOS_DATA)
                t.column(COLUMN_PHOTOS_OWNERID)
            })
            
            if let photoData = self.pngData() {
                let strBase64 = photoData.base64EncodedString(options: .lineLength64Characters)
                let insert = TABLE_PHOTOS.insert(COLUMN_PHOTOS_DATA <- strBase64, COLUMN_PHOTOS_OWNERID <- owner.uuidString)
                let rowid = try file.db?.run(insert)
                return rowid
            }
        } catch {
            debugPrint("Error saving photos!")
        }
        return nil
    }
    
    class func loadAllPhotos(for owner: UUID, from file: DatabaseFile) -> [UIImage] {
        var loadedPhotos: [UIImage] = []
        if let db = file.db {
            do {
                for photoRow in try db.prepare(TABLE_PHOTOS.filter(COLUMN_PHOTOS_OWNERID == owner.uuidString)) {
                    if let photoData = Data(base64Encoded: photoRow[COLUMN_PHOTOS_DATA], options: .ignoreUnknownCharacters) {
                        if let photo = UIImage(data: photoData) {
                            loadedPhotos.append(photo)
                        }
                    }
                }
            } catch {
                debugPrint("No photos found")
            }
        }
        return loadedPhotos
    }
    
    class func delete(for owner: UUID, from file: DatabaseFile) -> Bool {
        let dbPhotos = TABLE_PHOTOS.filter(COLUMN_PHOTOS_OWNERID == owner.uuidString)
        if let db = file.db {
            do {
                try db.run(dbPhotos.delete())
                return true
            } catch {
                debugPrint("Error deleting photos!")
                return false
            }
        }
        return false
    }
}
