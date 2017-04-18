//
//  productDetailsViewController.swift
//  AFinder
//
//  Created by Berksu on 16/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import MapKit
import Parse
import Spring


class productDetailsViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var saveButton: SpringButton!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var informationTextField: SpringTextView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var locationTextField: SpringTextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var test: UIStackView!
    
    var selectedItem:ownerData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //informationTextField.text = selectedItem.information
        initializations()
        
        //setup mapView
        mapView.delegate = self
        
        
        addAnnotation(location: selectedItem.position, title: selectedItem.nameOfProduct, subtitle: selectedItem.information)
        searchAddressFromLocation()
        
        // Initial values
        saveButton.isHidden = true
        
    }
    
    func initializations(){
        
        itemNameLabel.text = selectedItem.nameOfProduct
        dateLabel.text = dateToString(date: selectedItem.date)
        informationTextField.text = selectedItem.information
        
        if(selectedItem.urlImage != ""){
            let url = URL(string: selectedItem.urlImage)
            productImage.kf.setImage(with: url)
        }else{
            //change name for non imaged items
            productImage.image = UIImage(named: "ic_acc.png")
        }
        
        
        
        // Stackview
        for subview in test.subviews
        {
            if let item = subview as? UILabel
            {
                let tInt = (item.tag as? Int)!
                
                if (tInt < selectedItem.hashtags.count) {
                    item.isHidden = false
                    item.text = " #"+selectedItem.hashtags[item.tag] + " "
                }
                else{
                    item.isHidden = true
                    test.distribution = .fillEqually
                }
                
            }
        }
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        informationTextField.animation = "fadeOut"
        informationTextField.duration = 1
        informationTextField.animate()
        
        informationTextField.animateNext {
            self.informationTextField.animation = "fadeIn"
            self.informationTextField.duration = 1
            self.informationTextField.textColor = UIColor.black
            self.informationTextField.backgroundColor = UIColor.white
            self.informationTextField.animate()
        }
        
        
    }
    
    @IBAction func editButton(_ sender: Any) {
        
        informationTextField.isEditable = true
        informationTextField.textColor = UIColor.white
        informationTextField.backgroundColor = UIColor.black
        
        saveButton.animation = "fadeIn"
        saveButton.duration = 1
        saveButton.isHidden = false
        saveButton.animate()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        //show alert about pinnig
        let alert = UIAlertController(title:"Do you want to delete this item ?", message: "", preferredStyle : UIAlertControllerStyle.alert)
        
        //If user want to pin this point
        let deleteItem=UIAlertAction(title:"Delete it !",style: UIAlertActionStyle.default){ACTION in
            //show this point closer
            //self.centerMapOnLocation(location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            //add pin
            self.removeItemFromParse(objectId: self.selectedItem.objectId)
        }
        
        //If user do not want to pn this point
        let cancelDelete = UIAlertAction(title:"Cancel",style: UIAlertActionStyle.default){ACTION in
            //self.locationManager.startUpdatingLocation()
        }
        
        alert.addAction(deleteItem)
        alert.addAction(cancelDelete)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
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
    
    
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func addAnnotation(location: CLLocationCoordinate2D, title: String, subtitle: String){
        
        let point = customAnnotation(coordinate: location)
        point.image = UIImage(named: "CNN_International_logo_2014")
        point.name = title
        point.address = subtitle
        point.phone = "1111"
        mapView.addAnnotation(point)
        
        //go this location
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        
    }
    
    
    //test
    func searchAddressFromLocation(){
        
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: selectedItem.position.latitude, longitude: selectedItem.position.longitude)
        
        // Address dictionary
        var address = ""
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if(error == nil){
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                
                // Street address
                if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                    //print(street)
                    address = address + (street as String) + ", "
                }
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    //print(city)
                    address = address + (city as String)
                }
                
                // Country
                if let country = placeMark.addressDictionary!["Country"] as? NSString {
                    //print(country)
                    address = address + "/" + (country as String)
                }
                print("adres")
                print(address)
                self.locationTextField.text = address
                
            }else{
                self.informationTextField.text = "Address cannot be found !"
                print("address cannot be found")
                
            }
        })
        
        
    }
    
    
    
    func isPointInsideOfRegion(searchedPlace: String, itemLocation: CLLocation, searchedArea: Double){
        var localSearchRequest:MKLocalSearchRequest!
        var localSearch:MKLocalSearch!

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
            
            let searchedLocation = CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            print(searchedLocation.distance(from: itemLocation))
            
            if(searchedLocation.distance(from: itemLocation) < searchedArea){
                print("item found")
            }else{
                print("item is not here")
            }
            
        }
    
    }
    
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
