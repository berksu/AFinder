//
//  SearchTableViewCell.swift
//  AFinder
//
//  Created by Kutan on 21/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit
import Spring

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchItem: SpringLabel!
    @IBOutlet weak var dividerItem: SpringView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
