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
import Spring


struct items{
    var objectId: String
    var nameOfProduct:String
    var position:CLLocationCoordinate2D
    var date: Date
    var hashtags: [String]!
}

class CustomButton: UIButton {
    var product: customAnnotation!
}

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 1500

    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    
    var searchedKeyword : String!
    var isHashtagSearced : Bool! = false
    var searchedText : String!
    
    var allItems = [items!]()
    static var currentItemsOnScreen:[items?] = []
    
    var circleRadius:Double = 300
    var isDrawCircle = false
    
    
    var allCustomAnnotations:[customAnnotation] = []
    
    
    
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
        
        //getAllDataFromParse()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goSpecifiedAnnotation(_:)), name: NSNotification.Name(rawValue: "goSpecifiedAnnotation"), object: nil)
        
    }
    
    func goSpecifiedAnnotation(_ notification: NSNotification){
        //load data here
        if let item = notification.userInfo?["item"] as? items{
            let center = CLLocationCoordinate2D(latitude: item.position.latitude, longitude: item.position.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
            
            for i in 0..<allCustomAnnotations.count{
                if(allCustomAnnotations[i].objectID == item.objectId){
                    let tempColor = allCustomAnnotations[i].pinTintColor
                    allCustomAnnotations[i].pinTintColor = .purple
                    mapView.removeAnnotations(mapView.annotations)
                    mapView.addAnnotations(allCustomAnnotations)
                    mapView.selectAnnotation(allCustomAnnotations[i], animated: true)
                    allCustomAnnotations[i].pinTintColor = tempColor
                    break
                }
            }
            

            
        }
    }

    
    
    
    /*func getAllDataFromParse(){
        
        //gereklileri yükle
        let query = PFQuery(className: "Product")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects!{
                    
                    
                    let ownerDataTemp = items(objectId: object.objectId! , nameOfProduct:object["Product"] as! String, position: CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude), date: object["date"] as! Date, hashtags: object["hashtags"] as! [String])
                    self.allItems.append(ownerDataTemp)
                    
                    //go to the center
                    let center = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    
                    self.mapView.setRegion(region, animated: true)

                    
                }
            }
            else {
                print("Error ! Cannot reach database")
            }
        }

        
    }*/

    func getCurrentItems(){
        HomeViewController.currentItemsOnScreen.removeAll()
        let edge = mapView.edgePoints()
        print(edge.ne)
        print(edge.sw)
        for i in 0..<allItems.count{
            if(allItems[i].position.latitude <= edge.ne.latitude && allItems[i].position.latitude >= edge.sw.latitude && allItems[i].position.longitude >= edge.sw.longitude && allItems[i].position.longitude <= edge.ne.longitude){
                print(allItems[i].nameOfProduct)
                HomeViewController.currentItemsOnScreen.append(allItems[i])
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        //performSegue(withIdentifier: "homeViewSeque", sender: self)
        
    }
    

    @IBAction func getEdgeLocation(_ sender: UIButton) {
        let edge = mapView.edgePoints()
        print(edge.ne)
        print(edge.sw)
        
        for i in 0..<allItems.count{
            if(allItems[i].position.latitude <= edge.ne.latitude && allItems[i].position.latitude >= edge.sw.latitude && allItems[i].position.longitude >= edge.sw.longitude && allItems[i].position.longitude <= edge.ne.longitude){
                print(allItems[i].nameOfProduct)
            }
        }
        
        isDrawCircle = !isDrawCircle
        if(isDrawCircle){
            mapView.removeOverlays(mapView.overlays)
            let circle = MKCircle(center: mapView.centerCoordinate, radius: circleRadius)
            mapView.add(circle)
        }else{
            mapView.removeOverlays(mapView.overlays)
        }

        //if(location.latitude <= edge.ne.latitude && location.latitude >= edge.sw.latitude && location.longitude <= edge.sw.longitude && location.longitude >= edge.ne.longitude){
        //    print(object["Product"])
        //}
        //addRadiusCircle(location: CLLocation(latitude: mapView.centerCoordinate.latitude,longitude: mapView.centerCoordinate.longitude),radius: 200)

    }
 
    
    //renewed page
    override func viewWillAppear(_ animated: Bool) {
        //locationFinderInitialization()

        
        if searchedKeyword != nil {
            
            if(isHashtagSearced == true){                
                //remove annotaitons
                mapView.removeAnnotations(mapView.annotations)
                allCustomAnnotations.removeAll()
                //gereklileri yükle
                allItems.removeAll()
                let query = PFQuery(className: "Product")
                query.whereKey("hashtags", contains: searchedKeyword.substring(from: searchedKeyword.index(searchedKeyword.startIndex, offsetBy: 1)))
                query.findObjectsInBackground { (objects, error) in
                    if error == nil {
                        for object in objects!{
                            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude)
                            
                            let ownerDataTemp = items(objectId: object.objectId! , nameOfProduct:object["Product"] as! String, position: CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude), date: object["date"] as! Date, hashtags: object["hashtags"] as! [String])
                            self.allItems.append(ownerDataTemp)
                            
                            if object["information"] != nil{
                                self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, date: self.dateToString(date: object["date"] as! Date) , addingDate: object["date"] as! Date, tags: object["hashtags"] as! [String], information: object["information"] as! String, id: object.objectId!)
                            }else{
                                self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, date: self.dateToString(date: object["date"] as! Date) , addingDate: object["date"] as! Date, tags: object["hashtags"] as! [String], information: "", id: object.objectId!)
                            }
                        }
                        self.getCurrentItems()
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
            allCustomAnnotations.removeAll()
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
        //mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
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
    
    //Ekrana yuvarlak cizme kodu
    //func addRadiusCircle(location: CLLocation, radius: Double){
    //    mapView.removeOverlays(mapView.overlays)
    //    let circle = MKCircle(center: location.coordinate, radius: radius)
    //    mapView.add(circle)
    //}
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if(isDrawCircle){
            mapView.removeOverlays(mapView.overlays)
            let circle = MKCircle(center: mapView.centerCoordinate, radius: circleRadius)
            mapView.add(circle)
        }else{
            mapView.removeOverlays(mapView.overlays)
        }
        getCurrentItems()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = .red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.05)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    

    //func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //print("rendererForOverlay");
        //let renderer = MKPolylineRenderer(overlay: overlay)
        /*let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer*/
        
        //var overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        //overlayRenderer.lineWidth = 1.0
        //overlayRenderer.strokeColor = .red
        //overlayRenderer.circle = MKCircle(centerCoordinate: mapView.userLocation , radius: 1000)

        //return overlayRenderer
    //}

    
    
    

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
    }*/
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation")
        
        if annotationView == nil {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            annotationView!.isEnabled = true
            annotationView!.canShowCallout = false
            
            //let btn = UIButton(type: .detailDisclosure)
            //annotationView?.leftCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? customAnnotation {
            var tempAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            tempAnnotationView.pinTintColor = annotation.pinTintColor
            annotationView?.image = tempAnnotationView.image
            //annotationView?.pinTintColor = annotation.pinTintColor
        }
        
        //annotationView?.image = UIImage(named: "pinTest.png")
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
        //calloutView.productName.text = customAnnotation.name
        calloutView.date.text = customAnnotation.date
        
        // Stackview
        for subview in calloutView.stackViewTop.subviews
        {
            if let item = subview as? UILabel
            {
                let tInt = (item.tag as? Int)!
                
                if (tInt < customAnnotation.stacks.count) {
                    item.alpha = 1
                    item.isHidden = false
                    item.text = " #" + customAnnotation.stacks[item.tag] + " "
                }
                else{
                    //item.isHidden = true
                    item.alpha = 0
                    item.text = ""
                    calloutView.stackViewTop.distribution = .fillEqually
                }
                
            }
        }
        
        for subview in calloutView.stackViewBottom.subviews
        {
            if let item = subview as? UILabel
            {
                let tInt = (item.tag as? Int)!
                
                if (tInt < customAnnotation.stacks.count) {
                    item.alpha = 1
                    item.isHidden = false
                    item.text = " #" + customAnnotation.stacks[item.tag] + " "
                }
                else{
                    //item.isHidden = true
                    item.alpha = 0
                    item.text = ""
                    calloutView.stackViewBottom.distribution = .fillEqually
                }
                
            }
        }

        //calloutView.tags.text = customAnnotation.address
        //calloutView.info.text = customAnnotation.phone
        //calloutView.image.image = customAnnotation.image
       
        let button = CustomButton(frame: calloutView.infoButton.frame)
        button.product = customAnnotation
        button.addTarget(self, action: #selector(HomeViewController.info(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        
        
        let findbutton = CustomButton(frame: calloutView.findButton.frame)
        findbutton.product = customAnnotation
        findbutton.addTarget(self, action: #selector(HomeViewController.find(sender:)), for: .touchUpInside)
        calloutView.addSubview(findbutton)

        //calloutView.image.image = customAnnotation.image
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        
        view.bringSubview(toFront: calloutView)
        mapView.bringSubview(toFront: view)
        
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    
    func find(sender: CustomButton)
    {
        //show alert
        let alert = UIAlertController(title:"This item is found", message: "If you click yes, this item will be cleared on the map", preferredStyle : UIAlertControllerStyle.alert)
        
        //If user pressed yes
        let yesButton = UIAlertAction(title:"Yes",style: UIAlertActionStyle.default){ACTION in
            self.removeItemFromParse(objectId: sender.product.objectID)
        }
        
        let cancelButton = UIAlertAction(title:"Cancel",style: UIAlertActionStyle.default){ACTION in
            //self.locationManager.startUpdatingLocation()
        }
        
        alert.addAction(yesButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func info(sender: CustomButton)
    {
        //let v = sender.superview as! CustomCalloutView
        print("girdim alırım bir dal info")
        print(sender.product.name)
        print(sender.product.date)
        print(sender.product.stacks)
        print(sender.product.info)
        print(sender.product.objectID)
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
 
    
    
    func removeItemFromParse(objectId: String){
        let query = PFQuery(className: "Product")
        
        query.getObjectInBackground(withId: objectId) { (object, error) in
            if error == nil {
                
                object?.deleteInBackground(block: { (deleted, error) in
                    if(deleted){
                        print("Data Successfully removed")
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        
                        // we have a notification (single)
                        // pop it
                        haveNotification = true
                        directPass = true
                        initialViewIndex = 1
                        
                        self.present(viewController, animated: false, completion: nil)
                    }else{
                        print("Error!! Data cannot be removed from database")
                    }
                })
                
                
            }
            else {
                print("Error ! Cannot reach database")
            }
        }
        
    }
    
    
    
    
    
/*
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
*/
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getProductsFromDatabase(){
        allItems.removeAll()
        let query = PFQuery(className: "Product")
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects!{
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude)
                    
                    let ownerDataTemp = items(objectId: object.objectId! , nameOfProduct:object["Product"] as! String, position: CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude), date: object["date"] as! Date, hashtags: object["hashtags"] as! [String])
                    self.allItems.append(ownerDataTemp)
                    
                    if object["information"] != nil{
                        self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, date: self.dateToString(date: object["date"] as! Date) , addingDate: object["date"] as! Date, tags: object["hashtags"] as! [String], information: object["information"] as! String, id: object.objectId!)
                    }else{
                        self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, date: self.dateToString(date: object["date"] as! Date) , addingDate: object["date"] as! Date, tags: object["hashtags"] as! [String], information: "", id: object.objectId!)
                    }
                    
                    //self.addAnnotationFromDatabase(location: location, title: object["Product"] as! String, subtitle: object["information"] as! String)
                    //print(object["Product"])
                    //self.addAnnotationFromDatabase2(location: location, title: object["Product"] as! String, subtitle: object["information"] as! String, addingDate: object["date"] as! Date)
                }
                self.getCurrentItems()
                //go to the center
                let center = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.mapView.setRegion(region, animated: true)
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
    
    func addAnnotationFromDatabase(location: CLLocationCoordinate2D, title: String, date: String, addingDate:Date, tags: [String], information: String, id: String){
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day]
        //formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case
        
        let string = formatter.string(from: addingDate, to: now)
        var token = string?.components(separatedBy: " ")
        print (token?[0])

        
        let point = customAnnotation(coordinate: location)
        //let point = customAnnotation()
        //point.image = UIImage(named: "CNN_International_logo_2014")
        //point.coordinate = location
        point.objectID = id
        point.name = title
        point.date = date
        point.stacks = tags
        point.info = information
        //point.address = subtitle
        //point.phone = "1111"
        
        //point.pinTintColor = .green
        if(Int((token?[0])!)! < 7){
            point.pinTintColor = .green
        }else if(Int((token?[0])!)! > 7 && Int((token?[0])!)! < 15){
            point.pinTintColor = .yellow
        }else{
            point.pinTintColor = .red
        }

        allCustomAnnotations.append(point)
        
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
    
    
    
    
    
    
    //berksu annotation tests
    
    /*func addAnnotationFromDatabase2(location: CLLocationCoordinate2D, title: String, subtitle: String, addingDate:Date){
        
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
    }*/


}


//class MyPointAnnotation : MKPointAnnotation {
//    var pinTintColor: UIColor?
//}

typealias Edges = (ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D)

extension MKMapView {
    func edgePoints() -> Edges {
        let nePoint = CGPoint(x: self.bounds.maxX, y: self.bounds.origin.y)
        let swPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        let neCoord = self.convert(nePoint, toCoordinateFrom: self)
        let swCoord = self.convert(swPoint, toCoordinateFrom: self)
        return (ne: neCoord, sw: swCoord)
    }
}


