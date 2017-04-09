//
//  SignUpViewController.swift
//  AFinder
//
//  Created by Berksu on 09/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //sign up
    @IBAction func signUpButton(_ sender: UIButton) {
        let email = "berksu.kismet@ug.bilkent.edu.tr"
        let user = PFUser()
        user.username = username.text!
        user.password = password.text!
        user["name"] = name.text!
        user["surname"] = surname.text!
        user.email = email.lowercased()
        
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        
        user.signUpInBackground { (succeed, error) in
            if succeed{
                print("You are successfully signed up")
            }else{
                print("Sign up problems :(")
                print(error!)
            }
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
