//
//  AddLocationView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct AddLocationView: View {
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
            Divider()
            TextField("Name", text: $locationName)
                .padding(.top)
            TextField("Description", text: $locationDesc)
                .padding(.top)
            Spacer()
        }.padding()
    }
    
    func saveLocation() {
        self.dismissView()
    }
    
    func dismissView() {
        self.presentation.wrappedValue.dismiss()
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView()
    }
}
