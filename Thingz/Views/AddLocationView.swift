//
//  AddLocationView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct AddLocationView: View {
    var callback: (Location) -> Bool
    @Environment(\.presentationMode) var presentation
    @State private var locationName: String = ""
    @State private var locationDesc: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: self.dismissView) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: self.saveLocation) {
                    Text("Save")
                }
            }
            HStack {
                Spacer()
                Text("New Location")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            Divider()
            TextField("Name", text: $locationName)
                .padding(.top)
            TextField("Description", text: $locationDesc)
                .padding(.top)
            Spacer()
        }.padding()
    }
    
    func saveLocation() {
        if !self.locationName.isEmpty {
            let newLocation = Location(name: self.locationName, description: self.locationDesc)
            if callback(newLocation) {
                self.dismissView()
            }
        }
    }
    
    func dismissView() {
        self.presentation.wrappedValue.dismiss()
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(callback: { location in
            return true
        })
    }
}
