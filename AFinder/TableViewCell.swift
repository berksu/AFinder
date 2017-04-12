//
//  TableViewCell.swift
//  AFinder
//
//  Created by Kutan on 12/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemThumbImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemTagsStackView: UIStackView!
    @IBOutlet weak var itemDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
