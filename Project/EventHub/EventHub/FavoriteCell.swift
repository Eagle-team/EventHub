//
//  FavoriteCell.swift
//  EventHub
//
//  Created by Hoan Le on 10/6/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var dueDate : NSDate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.dueDate) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
}
