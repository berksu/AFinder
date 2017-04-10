//
//  SplashScreenViewController.swift
//  AFinder
//
//  Created by Kutan on 10/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Direct Home page için segueDirectHome
        // Login için segueSignIn
        
        if(PFUser.current() == nil){
            performSegue(withIdentifier: "segueSignIn", sender: self)
        }else{
            performSegue(withIdentifier: "segueDirectHome", sender: self)
        }
        
        //performSegue(withIdentifier: "", sender: self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Already logged in
        if segue.identifier == "segueSignIn"
        {
            
        }
        
        if segue.identifier == "segueDirectHome"
        {
            
        }
    }
    
}
