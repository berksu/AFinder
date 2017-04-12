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
import Parse

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 1500

    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    
    var searchedKeyword : String!
    var isHashtagSearced : Bool! = false
    var searchedText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setup mapView
        locationFinderInitialization()
        getProductsFromDatabase()
        
        print("asdasd")
        
        if searchedKeyword != nil {
            goSearchedPlace(searchedPlace: searchedKeyword)
        }
        
        
    }
    
    //renewed page
    override func viewWillAppear(_ animated: Bool) {
        //locationFinderInitialization()

        
        if searchedKeyword != nil {
            
            if(isHashtagSearced == true){                
                //remove annotaitons
                mapView.removeAnnotations(mapView.annotations)
                
                //gereklileri yükle
                let query = PFQuery(className: "Product")
                query.whereKey("hashtags", contains: searchedKeyword.substring(from: searchedKeyword.index(searchedKeyword.startIndex, offsetBy: 1)))
                query.findObjectsInBackground { (objects, error) in
                    if error == nil {
                        for object in objects!{
                            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude)
                            self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, subtitle: object["information"] as! String)
                        }
                    }
                    else {
                        print("Error ! Cannot reach database")
                    }
                }
            }else{
                goSearchedPlace(searchedPlace: searchedKeyword)
            }
            
            
        }else{
            print("yuklecem")
            //remove annotaitons
            mapView.removeAnnotations(mapView.annotations)
            //ekranı temizle
            getProductsFromDatabase()
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {        
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goUsersCurrentPosition(_ sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    
    func goSearchedPlace(searchedPlace :String){
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchedPlace
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let center = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        
            self.mapView.setRegion(region, animated: true)
            
        }

    }
    

    //initialize location finder for user
    public func locationFinderInitialization(){
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

    
    func getProductsFromDatabase(){
        let query = PFQuery(className: "Product")
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects!{
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude)
                    self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, subtitle: object["information"] as! String)
                    //print(object["Product"])
                }
            }
            else {
                print("Error ! Cannot reach database")
            }
        }
    
    }
    
    //add all lost items on the map
    func addAnnotationFromDatabase(location: CLLocationCoordinate2D, title: String, subtitle: String){
        
        //add pin
        let annotation = MKPointAnnotation()
        //annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation)
        
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
