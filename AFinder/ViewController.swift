//
//  ViewController.swift
//  AFinder
//
//  Created by Kutan on 21/03/2017.
//  Copyright © 2017 Argeka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var buttons : [UIButton]!
    
    var homeViewController : UIViewController!
    var findViewController : UIViewController!
    
    var viewControllers : [UIViewController]!
    @IBOutlet var buttonDividers : [UIImageView]!
    var buttonDivierImages : [UIImage]!
    var selectedIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        
        homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeView")
        
        findViewController = storyboard.instantiateViewController(withIdentifier: "FindView")
        
        viewControllers = [homeViewController,findViewController]
        
        let image : UIImage = UIImage(named:"divider_red")!
        let image_white : UIImage = UIImage(named:"divider_white")!
        
        buttonDivierImages = [image,image_white]
        buttonDividers[0].image = buttonDivierImages[0]
        
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        buttons[selectedIndex].isSelected = false
        
        let previousVC = viewControllers[selectedIndex]
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        //sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        
        
        buttonDividers[selectedIndex].image = buttonDivierImages[0]
        buttonDividers[previousIndex].image = buttonDivierImages[1]
        
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        
        vc.didMove(toParentViewController: self)
    }
}

