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
    
    var body: some View {
        NavigationView {
            List(locations, id: \.id) { location in
                LocationRowView(location: location)
            }
            .navigationBarTitle("Locations")
            .navigationBarItems(leading: Button(action: dismiss) {
                Image(systemName: "xmark")
            }
            .font(.title), trailing: Button(action: {}) {
                Image(systemName: "plus")
            }
            .font(.title))
        }.onAppear {
            self.loadLocationsFromFile()
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
