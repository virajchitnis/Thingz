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
        VStack {
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
            ScrollView(.horizontal) {
                HStack {
                    ForEach(self.location.photos, id: \.self) { image in
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

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(location: Location(name: "Box 1", description: "The box in the attic."))
    }
}
