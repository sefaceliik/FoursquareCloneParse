//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Sefa Çelik on 16.05.2020.
//  Copyright © 2020 Sefa Celik. All rights reserved.
//

import Foundation
import UIKit

class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLongitude = ""
    var placeLatitude = ""
    
    private init(){}
}



