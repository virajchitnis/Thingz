//
//  LocationsListView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct LocationsListView: View {
    var fileURL: URL
    var dismiss: () -> Void
    @State private var locations: [Location] = []
    @State private var showAddLocationPopover: Bool = false
    @State private var showEditLocationPopover: Bool = false
    
    var body: some View {
        NavigationView {
            List(locations, id: \.id) { location in
                NavigationLink(destination: ThingsListView(fileURL: self.fileURL, location: location)) {
                    LocationRowView(location: location)
                    .contextMenu {
                        Button(action: {
                            self.showEditLocationPopover = true
                        }) {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                        .popover(isPresented: self.$showEditLocationPopover) {
                            AddLocationView(location: location, callback: self.edit)
                                .frame(minWidth: 300)
                        }
                        Button(action: {
                            if self.delete(location: location) {
                                self.locations.removeAll(where: { $0.id == location.id })
                            }
                        }) {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                    }
                }
            }
            .onAppear {
                self.loadLocationsFromFile()
            }
            .navigationBarTitle("Locations")
            .navigationBarItems(leading: Button(action: dismiss) {
                Image(systemName: "xmark")
            }
            .font(.title), trailing: Button(action: {
                self.showAddLocationPopover = true
            }) {
                Image(systemName: "plus")
            }
            .popover(isPresented: $showAddLocationPopover) {
                AddLocationView(callback: self.save)
                    .frame(minWidth: 300)
            }
            .font(.title))
        }
    }
    
    func loadLocationsFromFile() {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            self.locations = Location.loadFromDatabase(file: dbFile)
        }
    }
    
    func save(newLocation: Location) -> Bool {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            if newLocation.save(file: dbFile) != nil {
                self.locations.append(newLocation)
                return true
            }
        }
        return false
    }
    
    func edit(location: Location) -> Bool {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            if location.update(in: dbFile) {
                loadLocationsFromFile()
                return true
            }
        }
        return false
    }
    
    func delete(location: Location) -> Bool {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            return Location.delete(location: location, from: dbFile)
        }
        return false
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        return LocationsListView(fileURL: URL(fileURLWithPath: "blah"), dismiss: {})
    }
}
