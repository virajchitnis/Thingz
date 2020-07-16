//
//  Location.swift
//  Thingz
//
//  Created by Viraj Chitnis on 7/16/20.
//  Copyright © 2020 Viraj Chitnis. All rights reserved.
//

import Foundation
import UIKit

class Location {
    var name: String
    var description: String
    var photos: [UIImage]
    
    init(name: String, description: String = "", photos: [UIImage] = []) {
        self.name = name
        self.description = description
        self.photos = photos
    }
}
