//
//  AddProductViewController.swift
//  AFinder
//
//  Created by Berksu on 05/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class AddProductViewController: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagInputField: UITextField!
    
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    
    var locationManager = CLLocationManager()
    var latestLocation : CLLocation? = nil
    var hashtags : Array<String> = []
    
    
    @IBOutlet weak var tutorialLabel: UILabel!
    var tutorialLabelTexts: Array<String> = []
    @IBOutlet weak var tagStackView: UIStackView!
    var tagViews : Array<UIView> = []
    
    var googleAPIKey = "AIzaSyDzr3gg8-NQqRnHv7VQ9jFS4jUzqJEVyXk"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    enum addOptions {
        case camera
        case gallery
        case textField
    }
    
    
    var option = addOptions.textField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeLocationManager()
        //initializeParseAnonymous()
        
        imagePicker.delegate = self
        //self.tagInputField.delegate = self
        tagInputField.addTarget(self, action: #selector(AddProductViewController.textFieldDidChange(_:)),
                                for: UIControlEvents.editingChanged)
        
        // Hide stackview
        hideStackView()
        self.hideKeyboardWhenTappedAround()
        self.tagInputField.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.a
    }
    
    //func initializeParseAnonymous(){
    //    PFUser.enableAutomaticUser()
    //    PFUser.current()?.saveInBackground()
    //}
    
    @IBAction func loadImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // Whenever an option is changed
    // Swap uiviews
    func onOptionChanged(){
        
        tutorialLabel.isHidden = true
        tagStackView.isHidden = false
    }
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        //addProduct(productName: hashtags[0], information: "kutan dayıda demedim mi", hashtags: hashtags)
        
        performSegue(withIdentifier: "segueLastPhase", sender: self)
    }
    
    
    
    
    @IBAction func openCamera(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    func cameraIconTapped(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func hideStackView (){

        for subview in tagStackView.subviews
        {
            if let item = subview as? UILabel
            {
                tagViews.append(subview)
                item.isHidden = true;
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.tagInputField.resignFirstResponder()
        return false
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        hashtags = separateHashtags(tags: textField.text!)
        // bu hastagleri kutan kutu kutu ayıracak
        
        tagStackView.isHidden = false
        tagStackView.distribution = .fillProportionally
        onOptionChanged()
        
        
        
        for subview in tagStackView.subviews
        {
            if let item = subview as? UILabel
            {
                let tInt = (item.tag as? Int)!
                
                if tInt < hashtags.count {
                    item.isHidden = false
                    item.text = " #"+hashtags[item.tag]+" "
                }
                
            }
        }

    }
    
    
    func separateHashtags(tags: String)->Array<String>{
        let tags = tags.components(separatedBy: ",")
        return tags
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
    

    


    
    //Save image
    /*func saveImage(){
     let originalImage = UIImageJPEGRepresentation(pickedImage.image!, 0.6)
     let compressed = UIImage(data : originalImage!)
     UIImageWriteToSavedPhotosAlbum(compressed!, nil, nil, nil)
     }*/
    
    
    
    
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHome" {
            
        }
        
        if segue.identifier == "segueLastPhase" {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! ProductPublishViewController
            destinationVC.pItemName = hashtags[0]
            destinationVC.pHashtags = hashtags
            destinationVC.productImage = imageView.image            
            
            if(latestLocation != nil){
                destinationVC.location = latestLocation?.coordinate
            }else{
                destinationVC.location = locationManager.location?.coordinate
            }
        }
     }
    
    
}



/// Image processing

extension AddProductViewController {
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("error")
            } else {
                // Parse the response
                //print(json)
                let responses: JSON = json["responses"][0]
                
                /*
                 // Get face annotations
                 let faceAnnotations: JSON = responses["faceAnnotations"]
                 if faceAnnotations != nil {
                 let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
                 
                 let numPeopleDetected:Int = faceAnnotations.count
                 
                 print(numPeopleDetected)
                 
                 var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
                 var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
                 
                 for index in 0..<numPeopleDetected {
                 let personData:JSON = faceAnnotations[index]
                 
                 // Sum all the detected emotions
                 for emotion in emotions {
                 let lookup = emotion + "Likelihood"
                 let result:String = personData[lookup].stringValue
                 emotionTotals[emotion]! += emotionLikelihoods[result]!
                 }
                 }
                 // Get emotion likelihood as a % and display in UI
                 for (emotion, total) in emotionTotals {
                 let likelihood:Double = total / Double(numPeopleDetected)
                 let percent: Int = Int(round(likelihood * 100))
                 print("\(emotion): \(percent)%\n")
                 }
                 } else {
                 print("No faces found")
                 }
                 */
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    //var labelResultsText:String = "Labels found: "
                    var labelResultsText:String = ""
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    print(labelResultsText)
                    self.tagInputField.text = labelResultsText
                    
                    // Put hastangs to the tagStackView
                    self.tagStackView.isHidden = false
                    self.hashtags = self.separateHashtags(tags: labelResultsText)
                    
                    for subview in self.tagStackView.subviews
                    {
                        if let item = subview as? UILabel
                        {
                            let tInt = (item.tag as? Int)!
                            
                            if tInt < self.hashtags.count {
                                item.isHidden = false
                                item.text = "#"+self.hashtags[item.tag]+" "
                            }
                            
                        }
                    }

                    
                    
                } else {
                    print("No labels found")
                }
            }
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true // You could optionally display the image here by setting imageView.image = pickedImage
            imageView.image = pickedImage
            //spinner.startAnimating()
            //faceResults.isHidden = true
            //labelResults.isHidden = true
            
            // Base64 encode the image and create the request
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
            tutorialLabel.isHidden = true
            tagStackView.distribution = .fillEqually
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

/// Networking

extension AddProductViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 5
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

