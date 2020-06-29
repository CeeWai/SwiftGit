//
//  MapViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 15/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var caseList: [Case] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    var lm : CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DataManager.createDatabase()
        
        loadCase()
        lm = CLLocationManager()
        lm?.delegate = self
        lm?.desiredAccuracy = kCLLocationAccuracyBest
        lm?.distanceFilter = 0
        lm?.requestWhenInUseAuthorization()
        lm?.startUpdatingLocation()
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
    
        mapView.delegate = self
    }
    
    func loadMarkers() {
        //var failedList: [Case] = []
        
        var count = 0
        for var cases in caseList {
            //print("WORKING ON COUNTRY: \(count)")
            var point = MKPointAnnotation()
            //print("CONFIRMED: \(cases.confirmed) in \(cases.country)")
            var amtCases = cases.confirmed
            var country = cases.country.replacingOccurrences(of: "*", with: "")
            //print(country)
            //var country = cases.country
            point.title = "\(country): \(amtCases)"
            point.subtitle = "Deaths: \(cases.deaths) Recovered: \(cases.recovered) Date: \(cases.date)"
            let geoCoder = CLGeocoder()
            //let locationCoord = CLLocationCoordinate2D(latitude: 4.2105, longitude: 101.9758)
            geoCoder.geocodeAddressString(country) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                    else {
                        // handle no location found
                        print("ERROR COUNTRY NOT FOUND: UNABLE TO GEOCODE COUNTRY \(country)")
                        //failedList.append(cases)
                        return
                    }
                    // Use your location
                    print("COORDINATES: \(location.coordinate)")
                    point.coordinate = location.coordinate
                }
            count += 1
            mapView.addAnnotation(point)
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        var location = locations.last!
        print ("\(location.coordinate.latitude), \(location.coordinate.longitude)")
        
    }
    
    
    // This allows you to change how the annotations look
    // to the user.
    //
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) ->
        MKAnnotationView? {
            // The user's current location is also considered an annotation
            // on the map. We are not going to override how it looks
            // so let's just return nil.
            //
            if annotation is MKUserLocation
            {
                return nil
            }
            // This behaves like the Table View's dequeue re-usable cell.
            //
            var annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: "pin")
            // If there aren't any reusable views to dequeue,
            // we will have to create a new one.
            //
            if annotationView == nil
            {
                var pinAnnotationView = MKPinAnnotationView()
                annotationView = pinAnnotationView
                //pinAnnotationView.glyphText = gTxt
                
            }
            // Assign the annotation (the 2nd parameter)
            // to the pin so that iOS knows where to position
            // it in the map.
            //
            annotationView?.annotation = annotation

            // Setting this to true allows the callout bubble
            // to pop up when the user clicks on the pin
            //
            annotationView?.canShowCallout = true
            //annotationView?.image = UIImage(named: "marker.png")
            return annotationView
    }
    
    func loadCase()
    {
        // Queue an asynchronous task on the background thread,
        // so that viewDidLoad will end immediately, while the
        // task programmed inside the dispatch will run at a
        // later time.
        //
        CaseDataManager.loadCase(onComplete:
            {
                caseListJsonDownloaded in
                // Set the news list downloaded from Reddit
                
                // to our own newsList variable.
                //
                self.caseList = caseListJsonDownloaded
                //print(" SELF.CASELIST: \(self.caseList)")
                
                DispatchQueue.main.async
                    {
                        // Tells the tableView to refresh itself.
                        //
                        // Since we are updating the user interface,
                        // we use DispatchQueue.main.async to
                        // instruct iOS to call reloadData in the
                        // main worker thread.
                        //
                        self.loadMarkers()
                        //self.mapView.reloadData()
                        
                }
        })
    }

}

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}
