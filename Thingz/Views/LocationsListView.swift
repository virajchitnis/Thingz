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
    
    var body: some View {
        NavigationView {
            List(locations, id: \.id) { location in
                LocationRowView(location: location)
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
                AddLocationView()
            }
            .font(.title))
        }
    }
    
    func loadLocationsFromFile() {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            self.locations = Location.loadFromDatabase(file: dbFile)
        }
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        return LocationsListView(fileURL: URL(fileURLWithPath: "blah"), dismiss: {})
    }
}
