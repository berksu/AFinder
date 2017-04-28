//
//  WishlistDetailViewController.swift
//  AFinder
//
//  Created by Berksu on 28/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import MapKit
import Spring
import Parse

class WishlistDetailViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var diameterOfSearchedArea: SpringTextView!
    @IBOutlet weak var address: SpringTextView!
    
    @IBOutlet weak var stacks: UIStackView!
    
    var selectedWishlistItem: wishlistItems!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        initializations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func initializations(){
        
        searchAddressFromLocation()
        
        date.text = dateToString(date: selectedWishlistItem.date)
        diameterOfSearchedArea.text = String(format: "%.01f", selectedWishlistItem.searchedAreaRadius) + " m"
        
        
        // Stackview
        for subview in stacks.subviews
        {
            if let item = subview as? UILabel
            {
                let tInt = (item.tag as? Int)!
                
                if (tInt < selectedWishlistItem.hashtags.count) {
                    item.isHidden = false
                    item.text = " #"+selectedWishlistItem.hashtags[item.tag] + " "
                }
                else{
                    item.isHidden = true
                    stacks.distribution = .fillEqually
                }
                
            }
        }
        
        
        //Image Test
        mapView.layer.borderWidth = 1
        mapView.layer.masksToBounds = false
        //productImage.layer.borderColor = UIColor(white: 1.0, alpha: 0.4).cgColor
        mapView.layer.borderColor = UIColor.black.cgColor
        mapView.backgroundColor = UIColor.clear
        mapView.layer.cornerRadius = mapView.frame.size.width/2
        mapView.clipsToBounds = true
        
        //go to the center
        let center = selectedWishlistItem.position
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        
        mapView.setRegion(region, animated: false)
        
        let circle = MKCircle(center: center, radius: selectedWishlistItem.searchedAreaRadius)
        mapView.add(circle)
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
    
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func addCircle(location: CLLocationCoordinate2D){
        
        /*let point = customAnnotation(coordinate: location)
         point.image = UIImage(named: "CNN_International_logo_2014")
         point.name = title
         point.address = subtitle
         point.phone = "1111"
         mapView.addAnnotation(point)
         */
        
        
    }
    
    
    
    //test
    func searchAddressFromLocation(){
        
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: selectedWishlistItem.position.latitude, longitude: selectedWishlistItem.position.longitude)
        
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
                self.address.text = address
                
            }else{
                self.address.text = "Address cannot be found !"
                print("address cannot be found")
                
            }
        })
        
        
    }

    
    @IBAction func deleteWishlistItemFromDatabase(_ sender: UIButton) {
        let query = PFQuery(className: "Wishlist")
        
        query.getObjectInBackground(withId: selectedWishlistItem.objectId) { (object, error) in
            if error == nil {
                
                object?.deleteInBackground(block: { (deleted, error) in
                    if(deleted){
                        print("Data Successfully removed")
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        
                        // we have a notification (single)
                        // pop it
                        //haveNotification = true
                        //directPass = true
                        //initialViewIndex = 0
                        
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
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "sequeGoBack", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeGoBack" {
            // Create a new variable to store the instance of PlayerTableViewController
            initialViewIndex = 1
            
            itemsTableViewShown = true
            wishlistTableViewShown = false
        }
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
