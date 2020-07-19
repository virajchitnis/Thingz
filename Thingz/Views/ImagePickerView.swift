//
//  ImagePickerView.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/19/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    var pickerType: UIImagePickerController.SourceType
    var callback: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = pickerType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Do nothing.
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(self)
    }
}

extension ImagePickerView {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.callback(unwrapImage)
                parent.presentation.wrappedValue.dismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentation.wrappedValue.dismiss()
        }
    }
}
