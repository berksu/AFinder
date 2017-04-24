//
//  testUIViewController.swift
//  AFinder
//
//  Created by Kutan on 22/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Spring

class testUIViewController: UIViewController {

    @IBOutlet weak var menuButton: SpringButton!
    @IBOutlet weak var menuButtonTop: SpringButton!
    @IBOutlet weak var menuButtonBottom: SpringButton!
    
    @IBOutlet weak var midDivider: SpringView!
    @IBOutlet weak var topDivider: SpringView!
    @IBOutlet weak var bottomDivider: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        midDivider.isHidden = true
        menuButtonTop.isHidden = true
        menuButtonBottom.isHidden = true
        topDivider.isHidden = true
        bottomDivider.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonOnClick(_ sender: Any) {
        
        menuButton.center.x = menuButton.center.x + 70
        menuButton.animation = "slideRight"
        menuButton.damping = 1
        menuButton.duration = 1
        menuButton.animate()
        
        
        menuButtonTop.isHidden = false
        
        menuButtonTop.animation = "slideRight"
        //menuButtonTop.damping = 1
        menuButtonTop.delay = 0.3
        menuButtonTop.duration = 1
        menuButtonTop.animate()
        
        
        menuButtonBottom.isHidden = false
        
        menuButtonBottom.animation = "slideRight"
        //menuButtonTop.damping = 1
        menuButtonBottom.delay = 0.3
        menuButtonBottom.duration = 1
        menuButtonBottom.animate()
        
        
        
        midDivider.isHidden = false
        
        midDivider.animation = "slideRight"
        midDivider.delay = 0.3
        midDivider.damping = 1
        midDivider.duration = 1
        midDivider.animate()
        midDivider.alpha = 0.6

        
        topDivider.isHidden = false
        
        topDivider.animation = "fadeIn"
        topDivider.delay = 1.5
        topDivider.damping = 1
        topDivider.duration = 1
        topDivider.animate()
        topDivider.alpha = 0.6

        
        bottomDivider.isHidden = false
        
        bottomDivider.animation = "fadeIn"
        bottomDivider.delay = 1.5
        bottomDivider.damping = 1
        bottomDivider.duration = 1
        bottomDivider.animate()
        bottomDivider.alpha = 0.6

        
        topDivider.animation = "flash"
        topDivider.repeatCount = 5
        topDivider.duration = 0.5
        topDivider.animate()
        
        bottomDivider.animation = "flash"
        bottomDivider.repeatCount = 5
        bottomDivider.duration = 0.5
        bottomDivider.animate()
        
        
        
        /*
        topDivider.isHidden = false
        
        topDivider.animation = "fadeIn"
        topDivider.delay = 1.2
        topDivider.damping = 1
        topDivider.duration = 1
        topDivider.animate()
        
        
        bottomDivider.isHidden = false
        
        bottomDivider.animation = "fadeIn"
        bottomDivider.delay = 1.2
        bottomDivider.damping = 1
        bottomDivider.duration = 1
        bottomDivider.animate()
 */
        
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
