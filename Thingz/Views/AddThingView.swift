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
    var callback: (Thing) -> Void
    @Environment(\.presentationMode) var presentation
    @State private var title: String = "New Thing"
    @State private var showBarcodeScanner: Bool = false
    @State private var showCameraView: Bool = false
    @State private var showImagePickerView: Bool = false
    @State private var thingName: String = ""
    @State private var thingDesc: String = ""
    @State private var thingQuantity: Int = 1
    @State private var thingBarcode: String = ""
    @State private var images: [UIImage] = []
    
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
            HStack {
                Spacer()
                Button(action: {
                    self.showCameraView = true
                }) {
                    Text("Take Photo")
                }
                .sheet(isPresented: $showCameraView, content: {
                    ImagePickerView(pickerType: .camera, callback: self.imageSelected)
                })
                .padding(.trailing)
                Button(action: {
                    self.showImagePickerView = true
                }) {
                    Text("Select Photo")
                }
                .sheet(isPresented: $showImagePickerView, content: {
                    ImagePickerView(pickerType: .photoLibrary, callback: self.imageSelected)
                })
                .padding(.leading)
                Spacer()
            }.padding(.top)
            VStack {
                GeometryReader { geo in
                    ScrollView {
                        ForEach(self.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width)
                        }
                    }
                }
            }
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
            self.images = thing.photos
        }
    }
    
    func saveThing() {
        if let thing = self.thing, !self.thingName.isEmpty {
            let updatedThing = Thing(id: thing.id, name: self.thingName, description: self.thingDesc, quantity: self.thingQuantity, barcode: self.thingBarcode, locationId: thing.locationId, photos: self.images)
            self.dismissView()
            callback(updatedThing)
        } else if !self.thingName.isEmpty {
            let newThing = Thing(name: self.thingName, description: self.thingDesc, quantity: self.thingQuantity, barcode: self.thingBarcode, locationId: self.location.id, photos: self.images)
            self.dismissView()
            callback(newThing)
        }
    }
    
    func imageSelected(image: UIImage) {
        self.images.append(image)
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
        })
    }
}
