//
//  SettingsViewController.swift
//  AFinder
//
//  Created by Kutan on 14/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutAction(_ sender: Any) {
        performSegue(withIdentifier: "segueLogout", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLogout" {
            PFUser.logOut()
        }
    }
    

}
