//
//  LocationToggle.swift
//  idderezovskiyPW2
//
//  Created by Ilya Derezovskiy on 07.03.2022.
//

import UIKit
import CoreLocation

class LocationToggle : UISwitch, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let locationToggle = UISwitch()
    
    public func getLocationLabel() -> UILabel {
        let locationLabel = UILabel()
        locationLabel.text = "Location"
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        return locationLabel
    }
    
    public func getLocationToggle() -> UISwitch {
        locationToggle.translatesAutoresizingMaskIntoConstraints = false
        return locationToggle
    }
}
