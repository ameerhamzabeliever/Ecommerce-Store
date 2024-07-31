//
//  LocationManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager:NSObject, CLLocationManagerDelegate{

    var timer: Timer?
    
    var location:CLLocation!
    var lat:String = ""
    var long:String = ""
    var locationManager :CLLocationManager!
    var locationUpdated:Bool = false
    var userDeniedLocation = false
    var userEnabledLocation = true

    var shouldSendLocation: Bool = true
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        
        return instance
    }()
        
    
    // MARK: - Initialization Method -
    
    override init() {
        super.init()
        location = CLLocation()
        locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        DispatchQueue.global(qos: .background).async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.delegate = self
                self?.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus){
        if status == .denied || status == .notDetermined || status == .restricted{
            userDeniedLocation = true
        }else{
            userDeniedLocation = false
        }
        
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first{
            locationUpdated = true
            location = loc
            lat = "\(loc.coordinate.latitude)"
            long = "\(loc.coordinate.longitude)"
            
        }
    }
    
}
