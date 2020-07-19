//
//  AddLocationView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/17/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct AddLocationView: View {
    var location: Location?
    var callback: (Location) -> Bool
    @Environment(\.presentationMode) var presentation
    @State private var title: String = "New Location"
    @State private var showBarcodeScanner: Bool = false
    @State private var locationName: String = ""
    @State private var locationDesc: String = ""
    @State private var locationBarcode: String = ""
    
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
                Text("\(self.title)")
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
            HStack {
                TextField("Barcode", text: $locationBarcode)
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
                self.displayExistingLocation()
            }
    }
    
    func displayExistingLocation() {
        if let location = self.location {
            self.title = "Edit \(location.name)"
            self.locationName = location.name
            self.locationDesc = location.description
            self.locationBarcode = location.barcode
        }
    }
    
    func saveLocation() {
        if let location = self.location, !self.locationName.isEmpty {
            location.name = self.locationName
            location.description = self.locationDesc
            location.barcode = self.locationBarcode
            if callback(location) {
                self.dismissView()
            }
        } else if !self.locationName.isEmpty {
            let newLocation = Location(name: self.locationName, description: self.locationDesc, barcode: self.locationBarcode)
            if callback(newLocation) {
                self.dismissView()
            }
        }
    }
    
    func barcodeScanned(barcode: String) {
        self.locationBarcode = barcode
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
