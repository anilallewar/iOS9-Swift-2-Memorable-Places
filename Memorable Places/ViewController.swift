//
//  ViewController.swift
//  Memorable Places
//
//  Created by Anil Allewar on 9/22/15.
//  Copyright © 2015 Anil Allewar. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        
        // Setup the location manager to zoom to current location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Start updating the location only when we don't have something pre-selected
        if activePlaceIndex == -1 {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            // Define zoom level for region
            let latDelta:CLLocationDegrees = 0.01
            let longDelta: CLLocationDegrees = 0.01
            
            let mkSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(placesArray[activePlaceIndex].getCoordinates(), mkSpan)
            
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.title = placesArray[activePlaceIndex].getAddress()
            annotation.coordinate = placesArray[activePlaceIndex].getCoordinates()
            
            mapView.addAnnotation(annotation)
        }
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action:"longPressOnMap:")
        uilpgr.minimumPressDuration = 2.0
        
        mapView.addGestureRecognizer(uilpgr)
    }

    func longPressOnMap(gestureRecognizer:UIGestureRecognizer){
        // Look for indication of first long press
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(mapView)
            
            let longPressCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.title = "Memorable Place"
            annotation.coordinate = longPressCoordinate
            
            mapView.addAnnotation(annotation)
            
            let currentPlace:PlacesData = PlacesData()
            currentPlace.setCoordinates(longPressCoordinate)
            
            // Have the address updated in the place before it is placed on the array
            self.getAddressFromCoordinate(currentPlace)
        }
    }
    
    /*
    Set the address in the PlacesData object before we add it to the array
    */
    private func getAddressFromCoordinate(currentPlace:PlacesData) -> Void {
        let location:CLLocation = CLLocation(latitude: currentPlace.getCoordinates().latitude, longitude: currentPlace.getCoordinates().longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var messageText:String = ""
            if (error != nil) {
                messageText = "\n" + "Reverse Geocode failed with error: " + (error?.localizedDescription)!
            } else if let placemark = CLPlacemark?(placemarks![0]) {
                
                messageText = "\n" + "Address: "
                if let street = placemark.thoroughfare {
                    messageText += street
                }
                if let subStreet = placemark.subThoroughfare {
                    messageText += ", " + subStreet
                }
                
                messageText += ", " + placemark.locality! + ", " + placemark.administrativeArea! + ", "
                    + placemark.postalCode!
            } else {
                messageText = "Can't find the location"
            }
            
            currentPlace.setAddress(messageText)
            
            //Add it to the array in the table view controller
            placesArray.append(currentPlace)
        })
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentUserLocation:CLLocation = locations[0]
        
        // Define zoom level for region
        let latDelta:CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        
        let mkSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let currentUserCoordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentUserLocation.coordinate.latitude, currentUserLocation.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentUserCoordinates, mkSpan)
        
        mapView.setRegion(region, animated: true)
        
        // Stop updating now that we have the user's location
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

