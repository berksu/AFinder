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
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //turn off the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //sign up
    @IBAction func signUpButton(_ sender: UIButton) {
        let user = PFUser()
        user.username = username.text!
        user.password = password.text!
        user["name"] = name.text!
        user.email = email.text!.lowercased()
        
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        
        user.signUpInBackground { (succeed, error) in
            if succeed{
                print("You are successfully signed up")
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as UIViewController
                // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                
                self.present(viewController, animated: false, completion: nil)
            }else{
                print("Sign up problems :(")
                print(error!)
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
