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
    @State private var showAddThingPopover: Bool = false
    
    var body: some View {
        List(things, id: \.id) { thing in
            ThingRowView(thing: thing)
        }
        .navigationBarTitle("Things")
        .navigationBarItems(trailing: Button(action: {
            self.showAddThingPopover = true
        }) {
            Image(systemName: "plus")
        }
        .popover(isPresented: $showAddThingPopover) {
            AddThingView(callback: self.save)
        }
        .font(.title))
    }
    
    func save(newThing: Thing) -> Bool {
        return true
    }
}

struct ThingsListView_Previews: PreviewProvider {
    static var previews: some View {
        ThingsListView(things: [Thing(name: "Thing 1", description: "Blah blah", barcode: "345345435", locationId: UUID())])
    }
}
