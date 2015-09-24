//
//  BusinessCell.swift
//  Yelp
//
//  Created by Anh Nguyen on 9/7/15.
//  Copyright (c) 2015 Anh Nguyen. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    var business: Business! {
        didSet {
            nameLabel.text = business.title
            //thumbImageView.setImageWithURL(business.imageURL)
            //categoriesLabel.text = business.categories
            addressLabel.text = business.address
            //reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            //ratingImageView.setImageWithURL(business.ratingImageURL)
            //distanceLabel.text = business.distance
        }
    }

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.layer.masksToBounds = true
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutIfNeeded() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
