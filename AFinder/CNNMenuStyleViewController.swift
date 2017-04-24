//
//  CNNMenuStyleViewController.swift
//  AFinder
//
//  Created by Kutan on 22/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Spring

class CNNMenuStyleViewController: UIViewController {

    @IBOutlet weak var bottomTopPart: SpringView!
    @IBOutlet weak var bottomBottomPart: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
        /*
        bottomTopPart.frame.origin.y = bottomBottomPart.frame.origin.y - 80
        bottomTopPart.animation = "slideUp"
        bottomTopPart.duration = 1
        bottomBottomPart.curve = "linear"
        bottomTopPart.damping = 1
        bottomTopPart.animate()
        
        bottomBottomPart.animation = "slideUp"
        bottomBottomPart.duration = 1
        bottomBottomPart.damping = 1
        bottomBottomPart.animate()
*/
 
        bottomBottomPart.frame.origin.y = bottomBottomPart.frame.origin.y + 80
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            //var basketTopFrame = self.bottomBottomPart.frame
            //basketTopFrame.origin.y -= basketTopFrame.size.height
            
            self.bottomTopPart.frame.origin.y = self.bottomTopPart.frame.origin.y - 80
            self.bottomBottomPart.frame.origin.y = self.bottomBottomPart.frame.origin.y - 80
            
            
            //var basketBottomFrame = self.basketBottom.frame
            //basketBottomFrame.origin.y += basketBottomFrame.size.height
            
            //self.basketTop.frame = basketTopFrame
            //self.basketBottom.frame = basketBottomFrame
        }, completion: { finished in
            
        })
        
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
