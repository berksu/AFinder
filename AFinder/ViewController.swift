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

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var contentView: UIView!
    
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
    
    var previousIndex : Int = 0
    
    @IBOutlet weak var dividerSpring: SpringImageView!
    @IBOutlet weak var dividerSpringFirst: SpringImageView!
    @IBOutlet weak var dividerFinds: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarController.delegate = self
        
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
        
        UIApplication.shared.isStatusBarHidden = true
        
        
        
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
            
            dividerSpringFirst.isHidden = true
            dividerSpring.animation = "slideRight"
            dividerSpring.isHidden = false
            dividerSpring.animate()
            //SpringImageView test = dividerFinds as! SpringImageView
            
        }
        
        if (selectedIndex == 0)  && (previousIndex != selectedIndex){
            dividerSpring.isHidden = true
            dividerSpringFirst.isHidden = false
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
