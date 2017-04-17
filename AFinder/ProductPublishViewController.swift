//
//  ProductPublishViewController.swift
//  AFinder
//
//  Created by Kutan on 17/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Parse


class ProductPublishViewController: UIViewController {

    var pHashtags : Array<String> = []
    var pItemName : String!
    var pItemNote : String!
    
    @IBOutlet weak var pItemThumbImage: UIImageView!
    @IBOutlet weak var pNoteTextField: UITextField!
    
    
    @IBAction func pPublishAction(_ sender: Any) {
        
        if pItemNote != "" {
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //pItemName = pHashtags[0]
        
        pNoteTextField.addTarget(self, action: #selector(AddProductViewController.textFieldDidChange(_:)),
                                for: UIControlEvents.editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        pItemNote = textField.text!
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
