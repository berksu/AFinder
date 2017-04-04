//
//  AddProduct.swift
//  AFinder
//
//  Created by Berksu on 03/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class AddProduct: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var latestLocation : CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeLocationManager()
        
        
        //addProduct(productName: "book", sender: "kutan", information: "Güvenlige teslim edildi")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initializeLocationManager(){
        //setup CL location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        latestLocation = locations.last!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getlocation()->PFGeoPoint{
        return PFGeoPoint(latitude: (locationManager.location?.coordinate.latitude)!, longitude:(locationManager.location?.coordinate.longitude)!)
    }
    

    func addProduct(productName : String, sender: String, information: String){
        let product = PFObject(className: "Product")
        product["Product"] = productName
        product["sender"] = sender
        product["date"] = Date()
        if(latestLocation != nil){
            product["location"] = PFGeoPoint(latitude: (latestLocation?.coordinate.latitude)!, longitude: (latestLocation?.coordinate.longitude)!)
        }else{
            product["location"] = getlocation()
        }
        product["information"] = information
        product.saveInBackground()
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
