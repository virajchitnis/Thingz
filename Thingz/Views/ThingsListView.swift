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
    @State private var showEditThingPopover: Bool = false
    @State private var showSearchPane: Bool = false
    
    var body: some View {
        List(location.things, id: \.id) { thing in
            NavigationLink(destination: ThingRowView(thing: thing)) {
                ThingRowView(thing: thing)
                .contextMenu {
                    Button(action: {
                        self.showEditThingPopover = true
                    }) {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                    .popover(isPresented: self.$showEditThingPopover) {
                        AddThingView(thing: thing, location: self.location, callback: self.edit)
                            .frame(minWidth: 300)
                    }
                    Button(action: {
                        self.delete(thing: thing)
                    }) {
                        Text("Delete")
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .navigationBarTitle("Things")
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.showSearchPane = true
            }) {
                Image(systemName: "magnifyingglass")
            }
            .font(.title)
            .padding(.trailing)
            .sheet(isPresented: $showSearchPane, content: {
                SearchView(fileURL: self.fileURL)
            })
            Button(action: {
                self.showAddThingPopover = true
            }) {
                Image(systemName: "plus")
            }
            .popover(isPresented: $showAddThingPopover) {
                AddThingView(location: self.location, callback: self.save)
                    .frame(minWidth: 300)
            }
            .font(.title)
        })
    }
    
    func save(newThing: Thing) {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            newThing.save(to: dbFile, completionHandler: { (rowid, error) in
                if error == nil {
                    self.location.things.append(newThing)
                }
            })
        }
    }
    
    func edit(thing: Thing) {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            thing.update(in: dbFile, completionHandler: { error in
                if error == nil {
                    if let thingIndex = self.location.things.firstIndex(where: { $0.id == thing.id }) {
                        self.location.things[thingIndex] = thing
                    }
                }
            })
        }
    }
    
    func delete(thing: Thing) {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            Thing.delete(thing: thing, from: dbFile, completionHandler: { error in
                if error == nil {
                    self.location.things.removeAll(where: { $0.id == thing.id })
                }
            })
        }
    }
}

struct ThingsListView_Previews: PreviewProvider {
    static var previews: some View {
        let things = [Thing(name: "Thing 1", description: "Blah blah", barcode: "345345435", locationId: UUID())]
        return ThingsListView(fileURL: URL(fileURLWithPath: "blah"), location: Location(name: "Blah", things: things))
    }
}
