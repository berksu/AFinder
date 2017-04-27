//
//  NotificationTableViewCell.swift
//  AFinder
//
//  Created by Kutan on 18/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import MapKit

class NotificationTableViewCell: UITableViewCell {


    @IBOutlet weak var stackTop: UIStackView!
    @IBOutlet weak var stackBottom: UIStackView!
    @IBOutlet weak var date: UILabel!
    
    var location: CLLocationCoordinate2D!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
