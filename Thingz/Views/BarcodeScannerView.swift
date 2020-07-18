//
//  BarcodeScannerView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/18/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI
import UIKit
import BarcodeScanner

struct BarcodeScannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        return BarcodeScannerViewController()
    }
    
    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {
        // Do nothing for now.
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
