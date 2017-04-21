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
                            self.addAnnotationFromDatabase2(location: location, title: object["Product"] as! String, subtitle: object["information"] as! String, addingDate: object["date"] as! Date)
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
    
    
    
    //test
    func testToSearchFromLocation(){
        
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary as Any)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
            }
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
            }
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
            }
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
        })
        
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
        //mapView.showsPointsOfInterest = false

    
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

    
    
    

    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    */
    
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
                    //self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, subtitle: object["information"] as! String)
                    //print(object["Product"])
                    self.addAnnotationFromDatabase2(location: location, title: object["Product"] as! String, subtitle: object["information"] as! String, addingDate: object["date"] as! Date)
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
        
    }
    
    
    func addAnnotationFromDatabase(location: CLLocationCoordinate2D, title: String, subtitle: String){
        
        let point = customAnnotation(coordinate: location)
        point.image = UIImage(named: "CNN_International_logo_2014")
        point.name = title
        point.address = subtitle
        point.phone = "1111"
        mapView.addAnnotation(point)
        
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    
    //berksu annotation tests
    
    func addAnnotationFromDatabase2(location: CLLocationCoordinate2D, title: String, subtitle: String, addingDate:Date){
        
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day]
        //formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case
        
        let string = formatter.string(from: addingDate, to: now)
        var token = string?.components(separatedBy: " ")
        print (token?[0])
        
        let point = MyPointAnnotation()
        point.title = title
        point.subtitle = subtitle
        point.coordinate = location
        
        //point.pinTintColor = .green
        if(Int((token?[0])!)! < 7){
            point.pinTintColor = .green
        }else if(Int((token?[0])!)! > 7 && Int((token?[0])!)! < 15){
            point.pinTintColor = .yellow
        }else{
            point.pinTintColor = .red
        }
        
        mapView.addAnnotation(point)
        
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            annotationView!.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.leftCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? MyPointAnnotation {
            annotationView?.pinTintColor = annotation.pinTintColor
        }
        
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let ac = UIAlertController(title: "oldu", message: "girdi", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }


}


class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
}


