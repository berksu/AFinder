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
import MapKit


// Check if we have an update
// Adding item , removing item
// Other ops.
var haveNotification : Bool = false
var initialViewIndex : Int = 0
var directPass : Bool = false

class ViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var searchListTableView: UITableView!
    
    
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
    @IBOutlet weak var bottomViewBottomPart: UIView!
    @IBOutlet weak var popularTagsStackView: UIStackView!
    var isBottomFirstOpening = false
    var isBottomMenuOpen : Bool = false
    var previousIndex : Int = 0
    
    @IBOutlet weak var dividerSpring: SpringImageView!
    @IBOutlet weak var dividerSpringFirst: SpringImageView!
    @IBOutlet weak var dividerFinds: UIImageView!
    
    var fadeCounter : CGFloat = 0.0
    
    //create a completer
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let sC = MKLocalSearchCompleter()
        sC.delegate = self
        return sC
    }()
    
    var searchSource: [String]?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarController.delegate = self
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.separatorStyle = .none
        
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
        // Hide the page title as default
        searchBarController.isHidden = false
        pageTitleLabel.isHidden = false;
        notificationView.isHidden = true
        bottomViewBottomPart.isHidden = true
        
        UIApplication.shared.isStatusBarHidden = true
        
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
        
        searchListTableView.isHidden = true
        
        searchBarController.tintColor = .red
        
        //güzel yol degil ama simdilik mecbur
        searchBarController.showsCancelButton = true
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        if haveNotification {
            displayNotification()
            onNotificationReceived()
        }
        
        didPressTab(buttons[initialViewIndex])
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

        searchListTableView.isHidden = true
        // # varsa
        // Parse search
        if(searchBar.text!.contains("#")){
            reloadSearchKeyword(searchedKeyword: searchBar.text, isHashtag: true)
        }else{
            // # yoksa
            reloadSearchKeyword(searchedKeyword: searchBar.text, isHashtag: false)
        }
        searchBar.endEditing(true)
        fadeCounter = 0.0
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            reloadSearchKeyword(searchedKeyword: nil, isHashtag: false)
            searchListTableView.isHidden = true
        }else if(!searchText.contains("#")){
            searchCompleter.queryFragment = searchText
            searchListTableView.isHidden = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchListTableView.isHidden = true
        searchBar.endEditing(true)
        fadeCounter = 0.0
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
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        fadeCounter = 0.0
        view.endEditing(true)
    }
    
    func profileImageHasBeenTapped(){
        
        /*
        
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
        */
        
        
        if (isBottomMenuOpen){
            closeBottomMenu()
            isBottomMenuOpen = false
        }
        else {
            openBottomMenu()
            isBottomMenuOpen = true
        }
        

    }
    
    func openBottomMenu(){
        
        bottomViewBottomPart.isHidden = false
        
        if(!isBottomFirstOpening) {
            self.bottomViewBottomPart.frame.origin.y = self.bottomViewBottomPart.frame.origin.y + bottomViewBottomPart.frame.size.height
        
            isBottomFirstOpening = true
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.bottomView.frame.origin.y = self.bottomView.frame.origin.y - self.bottomViewBottomPart.frame.size.height
            self.newAdImageView.frame.origin.y = self.newAdImageView.frame.origin.y -
                self.bottomViewBottomPart.frame.size.height
            
        }, completion: { finished in
            
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.bottomViewBottomPart.frame.origin.y = self.bottomViewBottomPart.frame.origin.y -
                self.bottomViewBottomPart.frame.size.height
            
        }, completion: { finished in
            
        })
        
        popularTagsStackView.frame.origin.x = popularTagsStackView.frame.origin.x - popularTagsStackView.frame.size.width - 50
        
        popularTagsStackView.isHidden = false
        
        let firstPos = popularTagsStackView.frame.origin.x
        
        UIView.animate(withDuration: 9.0, delay: 1.0, options: [.curveEaseOut,.repeat], animations: {
            
            for subview in self.popularTagsStackView.subviews
            {
                if let item = subview as? UILabel
                {
                    item.frame.origin.x = item.frame.origin.x + 830
                }
            }
            
        }, completion: { finished in
            self.popularTagsStackView.isHidden = true
            self.popularTagsStackView.frame.origin.x = firstPos
        })
        
    }
    
    func closeBottomMenu(){
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.bottomViewBottomPart.frame.origin.y = self.bottomViewBottomPart.frame.origin.y +
                self.bottomViewBottomPart.frame.size.height
            
            
        }, completion: { finished in
            self.bottomViewBottomPart.isHidden = true
            
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.bottomView.frame.origin.y = self.bottomView.frame.origin.y + self.bottomViewBottomPart.frame.size.height
            self.newAdImageView.frame.origin.y = self.newAdImageView.frame.origin.y +
                self.bottomViewBottomPart.frame.size.height
            
        }, completion: { finished in
            
        })

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
            
            
            if(directPass) {
                dividerSpringFirst.isHidden = true
                dividerSpring.isHidden = false
                return
            }
            
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
        if tableView == self.notificationsTableView {
            return 3
        }
        else if tableView == self.searchListTableView {
            if(searchSource != nil){
                return (searchSource?.count)!
            }else{
                return 0
            }
            
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.notificationsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewNotifications", for: indexPath) as! NotificationTableViewCell
            // Configure the cell...
            
            return cell
            
        }
        else if tableView == self.searchListTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarTableView", for: indexPath) as! SearchTableViewCell
            // Configure the cell...
            
            cell.searchItem.animation = "fadeIn"
            cell.searchItem.text = searchSource?[indexPath.row]
            cell.searchItem.duration = 0.7
            cell.searchItem.animate()
            
            return cell

        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarTableView", for: indexPath) as! SearchTableViewCell
            // Configure the cell...
            
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarController.text = searchSource?[indexPath.row]
        // # yoksa
        reloadSearchKeyword(searchedKeyword: searchBarController.text, isHashtag: false)
        searchBarController.endEditing(true)
        searchListTableView.isHidden = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}




extension ViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //get result, transform it to our needs and fill our dataSource
        self.searchSource = completer.results.map { $0.title }
        DispatchQueue.main.async {
           self.searchListTableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //handle the error
        print(error.localizedDescription)
    }
}


