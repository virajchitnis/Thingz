//
//  Thing.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/16/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import Foundation
import UIKit

class Thing {
    var name: String
    var description: String
    var barcode: String
    var photos: [UIImage]
    
    init(name: String, description: String = "", barcode: String = "", photos: [UIImage] = []) {
        self.name = name
        self.description = description
        self.barcode = barcode
        self.photos = photos
    }
}
