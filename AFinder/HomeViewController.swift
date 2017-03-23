//
//  HomeViewController.swift
//  AFinder
//
//  Created by Berksu on 22/03/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 1500
    var annotationsArray:Array<MKPointAnnotation>= []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setup mapView
        locationFinderInitialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //initialize location finder for user
    private func locationFinderInitialization(){
        //setup CL location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //setup mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
    
        //zoom the starting point
        //centerMapOnLocation(location: locationManager.location!)
        
    }
    


    //close to the map
    //private func centerMapOnLocation(location: CLLocation) {
    //    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
    //                                                              regionRadius * 2.0, regionRadius * 2.0)
    //    mapView.setRegion(coordinateRegion, animated: true)
    //}
    

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("rendererForOverlay");
        //let renderer = MKPolylineRenderer(overlay: overlay)
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    
    //add all lost items on the map
    func addAnnotationFromDatabase(location: CLLocation){
        
        //add pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.title = "Car Position"
        annotation.subtitle = "Your car is in here"
        
        annotationsArray.append(annotation)
        mapView.addAnnotations(annotationsArray)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
