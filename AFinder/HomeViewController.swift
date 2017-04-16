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

    
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "test")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let customAnnotation = view.annotation as! customAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.productName.text = customAnnotation.name
        calloutView.tags.text = customAnnotation.address
        calloutView.info.text = customAnnotation.phone
        //calloutView.image.image = customAnnotation.image
       
        let button = UIButton(frame: calloutView.tags.frame)
        button.addTarget(self, action: #selector(HomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        calloutView.image.image = customAnnotation.image
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    
    func callPhoneNumber(sender: UIButton)
    {
        print("bbbbb")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
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
    /*func addAnnotationFromDatabase(location: CLLocationCoordinate2D, title: String, subtitle: String){
        
        //add pin
        let annotation = MKPointAnnotation()
        //annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation)
        
    }*/
    
    
    func addAnnotationFromDatabase(location: CLLocationCoordinate2D, title: String, subtitle: String){
        
        let point = customAnnotation(coordinate: location)
        point.image = UIImage(named: "CNN_International_logo_2014")
        point.name = title
        point.address = subtitle
        point.phone = "1111"
        mapView.addAnnotation(point)
        
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
