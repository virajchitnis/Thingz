//
//  AddThingView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct AddThingView: View {
    var thing: Thing?
    var location: Location
    var callback: (Thing) -> Bool
    @Environment(\.presentationMode) var presentation
    @State private var title: String = "New Thing"
    @State private var showBarcodeScanner: Bool = false
    @State private var thingName: String = ""
    @State private var thingDesc: String = ""
    @State private var thingQuantity: Int = 1
    @State private var thingBarcode: String = ""
    
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
                Text("\(self.title)")
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
            Stepper(value: $thingQuantity, in: 1...1000) {
                Text("\(self.thingQuantity)")
            }
            HStack {
                TextField("Barcode", text: $thingBarcode)
                    .disabled(true)
                Button(action: {
                    self.showBarcodeScanner = true
                }) {
                    Text("Scan Barcode")
                }.sheet(isPresented: $showBarcodeScanner, content: {
                    BarcodeScannerView(callback: self.barcodeScanned)
                })
            }.padding(.top)
            Spacer()
        }
            .padding()
            .onAppear {
                self.displayExistingThing()
            }
    }
    
    func displayExistingThing() {
        if let thing = self.thing {
            self.title = "Edit \(thing.name)"
            self.thingName = thing.name
            self.thingDesc = thing.description
            self.thingQuantity = thing.quantity
            self.thingBarcode = thing.barcode
        }
    }
    
    func saveThing() {
        if let thing = self.thing, !self.thingName.isEmpty {
            let updatedThing = Thing(id: thing.id, name: self.thingName, description: self.thingDesc, quantity: self.thingQuantity, barcode: self.thingBarcode, locationId: thing.locationId)
            if callback(updatedThing) {
                self.dismissView()
            }
        } else if !self.thingName.isEmpty {
            let newThing = Thing(name: self.thingName, description: self.thingDesc, quantity: self.thingQuantity, barcode: self.thingBarcode, locationId: self.location.id)
            if callback(newThing) {
                self.dismissView()
            }
        }
    }
    
    func barcodeScanned(barcode: String) {
        self.thingBarcode = barcode
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
