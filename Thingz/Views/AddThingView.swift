//
//  AddThingView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct AddThingView: View {
    var location: Location
    var callback: (Thing) -> Bool
    @Environment(\.presentationMode) var presentation
    @State private var showBarcodeScanner: Bool = false
    @State private var thingName: String = ""
    @State private var thingDesc: String = ""
    @State private var thingBarcode: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: self.dismissView) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: self.saveThing) {
                    Text("Save")
                }
            }
            HStack {
                Spacer()
                Text("New Thing")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            Divider()
            TextField("Name", text: $thingName)
                .padding(.top)
            TextField("Description", text: $thingDesc)
                .padding(.top)
            Button(action: {
                self.showBarcodeScanner = true
            }) {
                Text("Scan Barcode")
            }.sheet(isPresented: $showBarcodeScanner, content: {
                BarcodeScannerView(code: self.$thingBarcode)
            })
            Spacer()
        }.padding()
    }
    
    func saveThing() {
        if !self.thingName.isEmpty, let barcode = self.thingBarcode {
            let newThing = Thing(name: self.thingName, description: self.thingDesc, barcode: barcode, locationId: self.location.id)
            if callback(newThing) {
                self.dismissView()
            }
        }
    }
    
    func dismissView() {
        self.presentation.wrappedValue.dismiss()
    }
}

struct AddThingView_Previews: PreviewProvider {
    static var previews: some View {
        AddThingView(location: Location(name: "Blah"), callback: { thing in
            return true
        })
    }
}
