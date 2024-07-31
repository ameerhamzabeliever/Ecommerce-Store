//
//  DirectionVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPin : NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        self.coordinate = location
        self.title = pinTitle
        self.subtitle = pinSubTitle
    }
    
}

class DirectionVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - PROPERTIES -
    
    var destinationName: String = ""
    var currentLat : Double?
    var currentLng : Double?
    var destinationLat : Double?
    var destinationLng : Double?
    
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        drawStoreLocationDirectionRoute()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.direction()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func manuallySetMapLocation(){
        self.mapView.mapType = MKMapType.standard
        let center = CLLocationCoordinate2D(latitude: 31.466745, longitude: 74.265768)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Emporium Mall"
        mapView.addAnnotation(annotation)
    }
    
    private func drawStoreLocationDirectionRoute(){
        
        if let currentLat = currentLat,
            let currentLng = currentLng,
            let destinationLat = destinationLat,
            let destinationLng = destinationLng  {
            
            let sourceLocation = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng)
            let destinationLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
            
            let sourcePin = CustomPin(pinTitle: "", pinSubTitle: "", location: sourceLocation)
            let destinationPin = CustomPin(pinTitle: self.destinationName, pinSubTitle: "", location: destinationLocation)
            self.mapView.addAnnotation(sourcePin)
            self.mapView.addAnnotation(destinationPin)
            
            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest.transportType = .automobile
            
            let direction = MKDirections(request: directionRequest)
            direction.calculate { response, error in
                guard let directionResponse = response else {return}
                let route = directionResponse.routes[0]
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
                self.mapView.delegate = self
            }
            
        }else{
            manuallySetMapLocation()
        }
        
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK: - EXTENSION FOR CLLocationManagerDelegate & MKMapViewDelegate -

extension DirectionVC: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
}



/*
 
 For Map Testing
 
 let sourceLocation = CLLocationCoordinate2D(latitude: 39.173209, longitude: -94.593933)
 let destinationLocation = CLLocationCoordinate2D(latitude: 38.643172, longitude: -90.177429)
 
 */
