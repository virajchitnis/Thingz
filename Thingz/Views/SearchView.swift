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
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText)
                        .keyboardType(.webSearch)
                }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 2)
                )
            }
            .padding()
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.headline)
                        Text("2345678453543")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                        Text("Description")
                            .foregroundColor(Color.gray)
                        Text("Type: Thing")
                            .padding(.top)
                    }
                    Spacer()
                    Text("5")
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
