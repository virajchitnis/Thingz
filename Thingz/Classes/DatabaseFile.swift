//
//  DatabaseFile.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/16/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import Foundation
import SQLite

class DatabaseFile {
    var path: URL
    var db: Connection?
    
    init?(path: URL) {
        self.path = path
        do {
            self.db = try Connection(path.absoluteString)
        } catch {
            debugPrint("Error opening file!")
            return nil
        }
    }
}
