//
//  FavoritesCell.swift
//  EventHub
//
//  Created by Hoan Le on 10/6/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
