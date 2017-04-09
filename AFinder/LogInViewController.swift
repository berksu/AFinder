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
    

    //sign up
    func signUp(userName: String, password: String, email:String) {
        let user = PFUser()
        user.username = userName
        user.password = password
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
    
    
    //log in
    func logIn(userName: String, password: String){
        PFUser.logInWithUsername(inBackground: userName, password: password) { (user, error) in
            if(user != nil){
                print("You are successfully logged in :)")
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
