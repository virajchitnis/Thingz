//
//  SearchRowView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/20/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct SearchRowView: View {
    var thing: Thing
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(self.thing.name)")
                    .font(.headline)
                Text("\(self.thing.barcode)")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                Text("\(self.thing.description)")
                    .foregroundColor(Color.gray)
            }
            Spacer()
            Text("\(self.thing.quantity)")
        }
    }
}

struct SearchRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRowView(thing: Thing(name: "Test", description: "Test", quantity: 5, barcode: "4535343", locationId: UUID(), photos: []))
    }
}
