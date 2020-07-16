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
        self.testSave()
        return VStack {
            HStack {
                Text("File Name")
                    .foregroundColor(.secondary)

                Text(document.fileURL.lastPathComponent)
            }

            Button("Done", action: dismiss)
        }
    }
    
    func testSave() {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("test.thingz")
        debugPrint(path)
        let testLocation = Location(name: "Box 1", description: "The box in the attic.")
        if let dbFile = DatabaseFile(path: path) {
            let rowid = testLocation.save(file: dbFile)
            debugPrint(rowid as Any)
        }
    }
}
