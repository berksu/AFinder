//
//  ProductPublishViewController.swift
//  AFinder
//
//  Created by Kutan on 17/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse

class ProductPublishViewController: UIViewController,UITextViewDelegate {

    var pHashtags : Array<String> = []
    var pItemName : String!
    var productImage: UIImage!
    var location: CLLocationCoordinate2D!
    
    var isTextFieldEditted = false
    
    
    
    @IBOutlet weak var informationAboutProduct: UITextView!
    
    @IBOutlet weak var pItemThumbImage: UIImageView!
    
    
    
    @IBAction func pPublishAction(_ sender: Any) {
        print(pHashtags)
        if isTextFieldEditted {
            addProduct(productName : pItemName, information: "", hashtags: pHashtags, location: location)
        }else{
            addProduct(productName : pItemName, information: informationAboutProduct.text , hashtags: pHashtags, location: location)
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pItemName = pHashtags[0]
        informationAboutProduct.delegate = self
        informationAboutProduct.text = "Give additional information about item. For example : I gave this phone to starbucks :)"
        informationAboutProduct.textColor = UIColor.lightGray
        
        pItemThumbImage.image = productImage

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if informationAboutProduct.textColor == UIColor.lightGray {
            informationAboutProduct.text = ""
            informationAboutProduct.textColor = UIColor.black
            isTextFieldEditted = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if informationAboutProduct.text == "" {
            
            informationAboutProduct.text = "Give additional information about item. For example : I gave this phone to starbucks :)"
            informationAboutProduct.textColor = UIColor.lightGray
             isTextFieldEditted = false
        }
    }
    
    
    func addProduct(productName : String, information: String, hashtags: Array<String>, location: CLLocationCoordinate2D){
        let product = PFObject(className: "Product")
        
        product.setObject(productName, forKey: "Product")
        product.setObject(information, forKey: "information")
        product.setObject(Date(), forKey: "date")
        product.setObject(PFUser.current(), forKey: "user")
        product.setObject(hashtags, forKey: "hashtags")
        
        product.setObject(PFGeoPoint(latitude: (location.latitude), longitude: (location.longitude)), forKey: "location")
        
        
        if(pItemThumbImage.image != nil){
            var imagedata = UIImagePNGRepresentation(pItemThumbImage.image!)
            
            // Resize the image if it exceeds the 2MB API limit
            if ((imagedata?.count)! > 2097152) {
                let oldSize: CGSize = pItemThumbImage.image!.size
                let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
                imagedata = resizeImage(newSize, image: pItemThumbImage.image!)
            }
            
            
            //let imageData: NSData = UIImageJPEGRepresentation(imagedata, 1.0)! as NSData
            let imageFile: PFFile = PFFile(name:"image.jpg", data:imagedata as! Data!)!
            
            product.setObject(imageFile, forKey: "image")
        }
        pItemThumbImage.image = nil
        
        product.saveInBackground(block: { (success, error) in
            if (success) {
                print("saving")
                self.performSegue(withIdentifier: "segueHome", sender: self)
                
            }else{
                print("cannot saving")
                print(error)
            }
        })
        
        
            
        
        /*product["Product"] = productName
         product["date"] = Date()
         if(latestLocation != nil){
         product["location"] = PFGeoPoint(latitude: (latestLocation?.coordinate.latitude)!, longitude: (latestLocation?.coordinate.longitude)!)
         }else{
         product["location"] = getlocation()
         }
         product["information"] = information
         product["hashtags"] = hashtags
         product["user"] = PFUser.current()
         
         
         product.saveInBackground()*/
    }
    
    //func getlocation()->PFGeoPoint{
    //    return PFGeoPoint(latitude: (locationManager.location?.coordinate.latitude)!, longitude:(locationManager.location?.coordinate.longitude)!)
    //}

    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
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
