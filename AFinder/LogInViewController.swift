//
//  LogInViewController.swift
//  AFinder
//
//  Created by Berksu on 06/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //logIn(userName: "berksu", password: "asd")
        //signUp(userName: "berksuK", password: "asd", email: "berksukismet@gmail.com")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                print("log in problems :(")
                print(error!)
            }
        }
    }

    
    
    //reset password with email
    func resetPasswordViaEmail(email: String){
        PFUser.requestPasswordResetForEmail(inBackground: email) { (success, error) in
            if(success){
                print("New password sent :)")
            }else{
                print("Password cannot be sent :(")
                print(error!)
            }
        }
    }
    
    
    //log out
    func logOut(){
        PFUser.logOut()
        print("log out")
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
