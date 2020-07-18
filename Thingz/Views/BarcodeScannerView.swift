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
    @Environment(\.presentationMode) var presentation
    @Binding var code: String?
    
    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        let scanner = BarcodeScannerViewController()
        scanner.codeDelegate = context.coordinator
        scanner.errorDelegate = context.coordinator
        scanner.dismissalDelegate = context.coordinator
        scanner.headerViewController.titleLabel.text = "Barcode Scanner"
        scanner.headerViewController.closeButton.setTitle("Close", for: .normal)
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {
        // Do nothing for now.
    }
    
    func makeCoordinator() -> BarcodeScannerView.Coordinator {
        return Coordinator(self)
    }
}

extension BarcodeScannerView {
    class Coordinator: NSObject, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate {
        var parent: BarcodeScannerView
        
        init(_ parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
            debugPrint(code)
            parent.code = code
            controller.reset(animated: true)
        }
        
        func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
            parent.presentation.wrappedValue.dismiss()
        }
        
        func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
            debugPrint(error)
        }
    }
}
