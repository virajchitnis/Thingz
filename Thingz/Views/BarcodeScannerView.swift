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
    var callback: (String) -> Void
    
    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        let scanner = BarcodeScannerViewController()
        scanner.codeDelegate = context.coordinator
        scanner.errorDelegate = context.coordinator
        scanner.dismissalDelegate = context.coordinator
        scanner.headerViewController.titleLabel.text = "Barcode Scanner"
        scanner.headerViewController.titleLabel.textColor = .gray
        scanner.headerViewController.closeButton.setTitle("Close", for: .normal)
        scanner.headerViewController.closeButton.tintColor = .red
        scanner.messageViewController.messages.scanningText = "Place the barcode within the window to scan."
        scanner.messageViewController.messages.processingText = "Processing..."
        scanner.isOneTimeSearch = true
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
            parent.callback(code)
            parent.presentation.wrappedValue.dismiss()
        }
        
        func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
            parent.presentation.wrappedValue.dismiss()
        }
        
        func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
            debugPrint(error)
        }
    }
}
