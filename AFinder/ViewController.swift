//
//  ViewController.swift
//  AFinder
//
//  Created by Kutan on 21/03/2017.
//  Copyright © 2017 Argeka. All rights reserved.
//

import UIKit
import Parse
import Spring


// Check if we have an update
// Adding item , removing item
// Other ops.
var haveNotification : Bool = false

class ViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var contentView: UIView!
    
    
    
    @IBOutlet weak var notificationIcon: SpringButton!
    @IBOutlet weak var singleNotificationView: SpringView!
    @IBOutlet weak var notificationView: SpringView!
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var searchBarController: UISearchBar!
    @IBOutlet var buttons : [UIButton]!
    
    var homeViewController : UIViewController!
    var findViewController : UIViewController!
    var addProductController : UIViewController!
    
    var pageTitles : [String]!
    
    var viewControllers : [UIViewController]!
    
    var selectedIndex : Int = 0
    
    @IBOutlet weak var newAdImageView: UIImageView!
    let recognizer = UITapGestureRecognizer()
    
    @IBOutlet weak var bottomView: SpringView!
    var previousIndex : Int = 0
    
    @IBOutlet weak var dividerSpring: SpringImageView!
    @IBOutlet weak var dividerSpringFirst: SpringImageView!
    @IBOutlet weak var dividerFinds: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarController.delegate = self
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        
        //Looks for single or multiple taps.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        //view.addGestureRecognizer(tap)
        
       
        newAdImageView.isUserInteractionEnabled = true
        recognizer.addTarget(self, action: #selector(ViewController.profileImageHasBeenTapped))
        
        newAdImageView.addGestureRecognizer(recognizer)
        
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        
        homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeView")
        findViewController = storyboard.instantiateViewController(withIdentifier: "FindView")
        addProductController = storyboard.instantiateViewController(withIdentifier: "ProductView")
        
        viewControllers = [homeViewController,findViewController,addProductController]
        
        pageTitles = ["Map,Add Product","Find Pages"]
        
        //let image : UIImage = UIImage(named:"divider_red")!
        //let image_white : UIImage = UIImage(named:"divider_black")!
        
        //buttonDivierImages = [image,image_white]
        //buttonDividers[0].image = buttonDivierImages[0]
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
        // Hide the page title as default
        searchBarController.isHidden = false
        pageTitleLabel.isHidden = false;
        notificationView.isHidden = true
        
        UIApplication.shared.isStatusBarHidden = true
        
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if haveNotification {
            displayNotification()
            onNotificationReceived()
        }
        
    }
    
    public func displayNotification(){
        singleNotificationView.animation = "slideRight"
        singleNotificationView.delay = 0.5
        singleNotificationView.duration = 1.5
        singleNotificationView.isHidden = false
        singleNotificationView.animate()
        
        singleNotificationView.animateNext {
            self.singleNotificationView.delay = 1.5
            self.singleNotificationView.animation = "fadeOut"
            self.singleNotificationView.animate()
        }
    }
    
    func onNotificationReceived(){
        
        notificationIcon.repeatCount = 3
        notificationIcon.animation = "fadeOut"
        notificationIcon.duration = 1.5
        notificationIcon.animate()
        
        notificationIcon.animateNext {
            self.notificationIcon.animation = "fadeIn"
            self.notificationIcon.duration = 1.5
            self.notificationIcon.animate()
        }
    }
    
    @IBAction func notificationButtonPressed(_ sender: Any) {
        
        
        notificationView.animation = "slideDown"
        notificationView.duration = 1
        notificationView.isHidden = false
        notificationView.curve = "linear"
        notificationView.animate()
        
        if selectedIndex == 0{
            notificationView.alpha = 0.7
        }
        else {
            notificationView.alpha = 1
        }
        
        
    }
    
    @IBAction func closeNotificationButton(_ sender: Any) {
                
        notificationView.animation = "fadeOut"
        notificationView.duration = 1
        notificationView.isHidden = false
        notificationView.curve = "linear"
        notificationView.animate()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomView.isHidden = false
        bottomView.animate()
        
    }
    
    // Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // # varsa
        // Parse search
        if(searchBar.text!.contains("#")){
            reloadSearchKeyword(searchedKeyword: searchBar.text, isHashtag: true)
        }else{
            // # yoksa
            reloadSearchKeyword(searchedKeyword: searchBar.text, isHashtag: false)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            reloadSearchKeyword(searchedKeyword: nil, isHashtag: false)
        }
    }
    
    //renew the page
    func reloadSearchKeyword(searchedKeyword: String?, isHashtag: Bool){
        let hc = viewControllers[0] as! HomeViewController
        hc.searchedKeyword = searchedKeyword
        
        hc.isHashtagSearced = isHashtag
        
        let previousVC = viewControllers[selectedIndex]
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        //sender.isSelected = true
        let vc = viewControllers[0]
        
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        
        vc.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func profileImageHasBeenTapped(){
        print("asd")
        let previousVC = viewControllers[selectedIndex]
        
        notificationView.alpha = 1
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        //sender.isSelected = true
        let vc = viewControllers[2]
        
        
        //buttonDividers[selectedIndex].image = buttonDivierImages[0]
        //buttonDividers[previousIndex].image = buttonDivierImages[1]
        
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        
        pageTitleLabel.isHidden = false;
        //pageTitleLabel.text = "Finds"
        searchBarController.isHidden = true
        
        vc.didMove(toParentViewController: self)
        

    }

    
    @IBAction func didPressTab(_ sender: UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        buttons[selectedIndex].isSelected = false
        
        let previousVC = viewControllers[selectedIndex]
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        //sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        
        if (selectedIndex == 1)  && (previousIndex != selectedIndex){
            
            notificationView.alpha = 1
            dividerSpringFirst.isHidden = true
            dividerSpring.animation = "slideRight"
            dividerSpring.isHidden = false
            dividerSpring.animate()
            //SpringImageView test = dividerFinds as! SpringImageView
            
        }
        
        if (selectedIndex == 0)  && (previousIndex != selectedIndex){
            dividerSpring.isHidden = true
            notificationView.alpha = 0.75
            dividerSpringFirst.isHidden = false
            dividerSpringFirst.delay = 0
            dividerSpringFirst.animation = "slideLeft"
            dividerSpringFirst.animate()
        }
        
        //buttonDividers[selectedIndex].image = buttonDivierImages[0]
        //buttonDividers[previousIndex].image = buttonDivierImages[1]
        
        if selectedIndex == 0{
            searchBarController.isHidden = false
        }
        else{
            searchBarController.isHidden = true
        }
        
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        
        
        //pageTitleLabel.text = pageTitles[selectedIndex]
        vc.didMove(toParentViewController: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewNotifications", for: indexPath) as! NotificationTableViewCell
        // Configure the cell...
        
        return cell
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
