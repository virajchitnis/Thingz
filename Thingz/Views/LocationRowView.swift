//
//  LocationRowView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct LocationRowView: View {
    var body: some View {
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
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView()
    }
}
