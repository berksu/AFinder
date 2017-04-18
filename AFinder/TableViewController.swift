//
//  TableViewController.swift
//  AFinder
//
//  Created by Kutan on 12/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse
import Kingfisher


struct ownerData{
    var objectId:String
    var nameOfProduct:String
    var information: String
    var date:Date
    var hashtags:[String]
    var position:CLLocationCoordinate2D
    var urlImage: String
}

class TableViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{

    
    var allData = [ownerData!]()
    var selectedData : ownerData!
    
    // Spinner before tableview load
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getUsersOwnItem()
        
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        var attr = NSDictionary(object: UIFont(name: "Quicksand-Bold", size: 12.0)!, forKey: NSFontAttributeName as NSCopying)
        self.segmentControl.setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
                
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewItem", for: indexPath) as! TableViewCell
        
        cell.itemTitleLabel.text = allData[indexPath.row].nameOfProduct
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: allData[indexPath.row].date)
        
        cell.itemDateLabel.text = dateString
        
        if(allData[indexPath.row].urlImage != ""){
            let url = URL(string: allData[indexPath.row].urlImage)
            cell.itemThumbImageView.kf.setImage(with: url)
        }else{
            //change name for non imaged items
            cell.itemThumbImageView.image = UIImage(named: "ic_acc.png")
        }
        
        //print("hastags count \(allData[indexPath.row].hashtags.count)")
        // Stackview
        for subview in cell.itemTagsStackView.subviews
        {
            if let item = subview as? UILabel
            {
                let tInt = (item.tag as? Int)!
                
                if (tInt < allData[indexPath.row].hashtags.count) {
                    item.isHidden = false
                    item.text = " #"+allData[indexPath.row].hashtags[item.tag] + " "
                }
                else{
                    item.isHidden = true
                    cell.itemTagsStackView.distribution = .fillEqually
                }
                
            }
        }
        
        
        
        // Configure the cell...
        
        return cell
    }
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getUsersOwnItem(){
        
        let query = PFQuery(className: "Product")
        query.whereKey("user", equalTo: PFUser.current()!)
        
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects!{
                    
                    var urlOfImage = ""
                    if(object["image"] != nil){
                        let userImageFile = object["image"] as! PFFile
                        urlOfImage = userImageFile.url!
                    }
                    
                    var itemInfo = ""
                    if(object["information"] != nil){
                        itemInfo = object["information"] as! String
                    }
                    
                    
                    
                    let ownerDataTemp = ownerData(objectId: object.objectId!, nameOfProduct:object["Product"] as! String, information: itemInfo ,date:object["date"] as! Date, hashtags:object["hashtags"] as! [String], position: CLLocationCoordinate2D(latitude: (object["location"] as AnyObject).latitude, longitude: (object["location"] as AnyObject).longitude), urlImage: urlOfImage)
                    self.allData.append(ownerDataTemp)
                    
                }
                self.itemsTableView.reloadData()
            }
            else {
                print("Error ! Cannot reach database")
            }
        }
        
    }
    
    // Whenever the user selects a row , open a new viewcontroller
    // Display item details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData = allData[indexPath.row]
        performSegue(withIdentifier: "segueItemDetails", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueItemDetails" {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! productDetailsViewController
            destinationVC.selectedItem = selectedData
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}



