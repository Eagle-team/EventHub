//
//  EventCell.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var eventAddress: UILabel!
    
    @IBOutlet weak var eventCity: UILabel!
    
    @IBOutlet weak var eventPoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
