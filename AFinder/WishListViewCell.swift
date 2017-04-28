//
//  WishListViewCell.swift
//  AFinder
//
//  Created by Kutan on 28/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import UIKit

class WishListViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var stackViewTop: UIStackView!
    @IBOutlet weak var stackViewBottom: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
