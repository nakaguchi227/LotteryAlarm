//
//  MyLocation.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/15.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import CoreLocation
import UIKit

class MyLocation{
    
    let msg = "ハロー"

    func reverseGeocode(lat: Double, lon: Double, complete:@escaping (_ o:[CLPlacemark])->Void){
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, Error) in
            guard let placemarks = placemark else{
                return
            }
            complete(placemarks)
        }
    }
}
