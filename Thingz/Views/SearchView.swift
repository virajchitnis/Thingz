//
//  SearchView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/20/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentation
    var fileURL: URL
    @State private var showBarcodeScanner: Bool = false
    @State private var filteredThings: [Thing] = []
    @State private var searchText: String = ""
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.searchText
        }, set: {
            self.searchText = $0
            self.executeSearch(withKey: $0)
        })
        
        return VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: binding)
                        .keyboardType(.webSearch)
                    Button(action: {
                        self.showBarcodeScanner = true
                    }) {
                        Image(systemName: "barcode.viewfinder")
                    }
                    .font(.title)
                    .padding(.all, 2)
                    .sheet(isPresented: $showBarcodeScanner, content: {
                        BarcodeScannerView(callback: self.barcodeScanned)
                    })
                }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray, lineWidth: 2)
                )
            }
            .padding()
            List(self.filteredThings, id: \.id) { thing in
                SearchRowView(thing: thing)
            }
        }
    }
    
    func executeSearch(withKey key: String) {
        if let dbFile = DatabaseFile(path: self.fileURL) {
            Thing.search(withKey: key, in: dbFile, completionHandler: { (matchingThings, error) in
                if error == nil {
                    self.filteredThings = matchingThings
                }
            })
        }
    }
    
    func barcodeScanned(barcode: String) {
        self.searchText = barcode
        self.executeSearch(withKey: barcode)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(fileURL: URL(fileURLWithPath: "blah"))
    }
}
