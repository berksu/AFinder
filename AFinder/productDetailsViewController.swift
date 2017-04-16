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

class productDetailsViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var informationTextField: UITextView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!


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
        testToSearchFromLocation()
    }

    func initializations(){
        
        itemNameLabel.text = selectedItem.nameOfProduct
        dateLabel.text = dateToString(date: selectedItem.date)

        
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
                
                if(tInt > selectedItem.hashtags.count){
                    item.isHidden = true
                    test.distribution = .fillEqually
                }
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        removeItemFromParse(objectId: selectedItem.objectId)
    }

    @IBAction func closeButton(_ sender: UIButton) {
    }
    
    
    func removeItemFromParse(objectId: String){
        print("girdiiii")
        let query = PFQuery(className: "Product")
        
        query.getObjectInBackground(withId: objectId) { (object, error) in
            if error == nil {
                
                object?.deleteInBackground(block: { (deleted, error) in
                    if(deleted){
                        print("Data Successfully removed")
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
    func testToSearchFromLocation(){
        
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
                self.informationTextField.text = address

            }else{
                self.informationTextField.text = "Address cannot be found !"
                print("address cannot be found")
               
            }
        })
        
        
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
