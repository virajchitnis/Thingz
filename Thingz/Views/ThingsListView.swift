//
//  ThingsListView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct ThingsListView: View {
    var fileURL: URL
    @ObservedObject var location: Location
    @State private var showAddThingPopover: Bool = false
    
    var body: some View {
        List(location.things, id: \.id) { thing in
            ThingRowView(thing: thing)
            .contextMenu {
                Button(action: {
                    if self.delete(thing: thing) {
                        self.location.things.removeAll(where: { $0.id == thing.id })
                    }
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                }
            }
        }
        .navigationBarTitle("Things")
        .navigationBarItems(trailing: Button(action: {
            self.showAddThingPopover = true
        }) {
            Image(systemName: "plus")
        }
        .popover(isPresented: $showAddThingPopover) {
            AddThingView(location: self.location, callback: self.save)
        }
        .font(.title))
    }
    
    func save(newThing: Thing) -> Bool {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            if newThing.save(file: dbFile) != nil {
                self.location.things.append(newThing)
                return true
            }
        }
        return false
    }
    
    func delete(thing: Thing) -> Bool {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            return Thing.delete(thing: thing, from: dbFile)
        }
        return false
    }
}

struct ThingsListView_Previews: PreviewProvider {
    static var previews: some View {
        let things = [Thing(name: "Thing 1", description: "Blah blah", barcode: "345345435", locationId: UUID())]
        return ThingsListView(fileURL: URL(fileURLWithPath: "blah"), location: Location(name: "Blah", things: things))
    }
}