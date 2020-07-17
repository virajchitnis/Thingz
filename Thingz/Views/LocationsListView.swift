//
//  LocationsListView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct LocationsListView: View {
    var dismiss: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Box 1")
                            .font(.headline)
                        Text("The box in the attic.")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                    Text("25 things")
                        .font(.body)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationBarTitle("Locations")
            .navigationBarItems(leading: Button(action: dismiss) {
                Image(systemName: "xmark")
            }
            .font(.title), trailing: Button(action: {}) {
                Image(systemName: "plus")
            }
            .font(.title))
        }
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView(dismiss: {})
    }
}
