//
//  DocumentView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/16/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct DocumentView: View {
    var document: UIDocument
    var dismiss: () -> Void

    var body: some View {
        LocationsListView(fileURL: self.document.fileURL, dismiss: self.dismiss)
    }
    
    func testSave() {
        let path = self.document.fileURL
        let testLocation = Location(name: "Box 1", description: "The box in the attic.")
        let testThing = Thing(name: "Something")
        if let dbFile = DatabaseFile(path: path) {
            var rowid = testLocation.save(file: dbFile)
            debugPrint(rowid as Any)
            rowid = testThing.save(file: dbFile)
            debugPrint(rowid as Any)
        }
    }
    
    func testLoad() {
        let path = self.document.fileURL
        if let dbFile = DatabaseFile(path: path) {
            let locations = Location.loadFromDatabase(file: dbFile)
            let things = Thing.loadFromDatabase(file: dbFile)
            debugPrint(locations)
            debugPrint(things)
        }
    }
}
