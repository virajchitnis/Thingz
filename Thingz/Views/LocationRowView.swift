//
//  LocationRowView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct LocationRowView: View {
    var location: Location
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(self.location.name)")
                    .font(.headline)
                Text("\(self.location.barcode)")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Text("\(self.location.description)")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            Text("\(self.location.things.count) things")
                .font(.body)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(location: Location(name: "Box 1", description: "The box in the attic."))
    }
}
