//
//  LogInViewController.swift
//  AFinder
//
//  Created by Berksu on 06/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse
import Spring

class LogInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var resendPasswordEmail: UITextField!
    
    @IBOutlet weak var usernameLabel: SpringLabel!
    @IBOutlet weak var passwordLabel: SpringLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //logIn(userName: "berksu", password: "asd")
        //signUp(userName: "berksuK", password: "asd", email: "berksukismet@gmail.com")
        
        //turn off the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        forgotPasswordView.isHidden = true

        PFUser.requestPasswordResetForEmail(inBackground: resendPasswordEmail.text!) { (success, error) in
            if(success){
                print("New password sent :)")
            }else{
                print("Password cannot be sent :(")
                print(error!)
            }
        }

    }
    
    //log in
    @IBAction func logInButton(_ sender: UIButton) {
        PFUser.logInWithUsername(inBackground: username.text! , password: password.text!) { (user, error) in
            if(user != nil){
                print("You are successfully logged in :)")
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as UIViewController
                // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                
                self.present(viewController, animated: false, completion: nil)
            }else{
                // Invalid login fields
                self.wrongInputFields()
                print("log in problems :(")
                
                
                print(error!)
            }
        }
    }
    
    func wrongInputFields(){
        usernameLabel.textColor = UIColor.red
        usernameLabel.animation = "fadeOut"
        usernameLabel.duration = 0.5
        usernameLabel.animate()
        
        usernameLabel.animateNext {
            self.usernameLabel.animation = "fadeIn"
            self.usernameLabel.animate()
        }
        
        passwordLabel.textColor = UIColor.red
        passwordLabel.animation = "fadeOut"
        passwordLabel.duration = 0.5
        passwordLabel.animate()
        
        passwordLabel.animateNext {
            self.passwordLabel.animation = "fadeIn"
            self.passwordLabel.animate()
        }

    }
    
    
    //Calls this function when the tap is recognized.
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    //reset password with email
    @IBAction func forgotPasswordAction(_ sender: Any) {
        forgotPasswordView.isHidden = false
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
