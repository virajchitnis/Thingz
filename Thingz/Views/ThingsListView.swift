//
//  ThingsListView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct ThingsListView: View {
    var things: [Thing]
    
    var body: some View {
        List(things, id: \.id) { thing in
            ThingRowView(thing: thing)
        }
        .navigationBarTitle("Things")
        .navigationBarItems(trailing: Button(action: {}) {
            Image(systemName: "plus")
        }
        .font(.title))
    }
}

struct ThingsListView_Previews: PreviewProvider {
    static var previews: some View {
        ThingsListView(things: [Thing(name: "Thing 1", description: "Blah blah", barcode: "345345435", locationId: UUID())])
    }
}
