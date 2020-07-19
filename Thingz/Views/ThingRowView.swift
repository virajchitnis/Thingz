//
//  ThingRowView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct ThingRowView: View {
    var thing: Thing
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(self.thing.name)")
                        .font(.headline)
                    Spacer()
                    Text("\(self.thing.barcode)")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("\(self.thing.description)")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    Spacer()
                    Text("\(self.thing.quantity)")
                }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(self.thing.photos, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }
                }.padding()
            }
        }
    }
}

struct ThingRowView_Previews: PreviewProvider {
    static var previews: some View {
        ThingRowView(thing: Thing(name: "Thing 1", description: "Blah blah", barcode: "345345435", locationId: UUID()))
    }
}
