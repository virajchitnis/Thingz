//
//  ThingsListView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct ThingsListView: View {
    var body: some View {
        List {
            VStack(alignment: .leading) {
                HStack {
                    Text("Thing 1")
                        .font(.headline)
                    Spacer()
                    Text("345366566")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
                Text("Something stored somewhere.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
        }
        .navigationBarTitle("Things", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}) {
            Image(systemName: "plus")
        }
        .font(.title))
    }
}

struct ThingsListView_Previews: PreviewProvider {
    static var previews: some View {
        ThingsListView()
    }
}
