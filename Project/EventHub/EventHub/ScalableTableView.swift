//
//  ScalableTableView.swift
//  EventHub
//
//  Created by Anh Nguyen on 10/3/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

@objc protocol ScaleTableViewTransform {
    var miniumScale:CGFloat {get};
    func transformCell(forScale scale:CGFloat);
}


class ScalableTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews();
        self.transform();
    }
    
    private func transform()->Void {
        
        for indexPath in self.indexPathsForVisibleRows! {
            if let cell = self.cellForRowAtIndexPath(indexPath) as? ScaleTableViewTransform {
                let distanceFromCenter = self.computeDistanceFromCenter(indexPath);
                cell.transformCell(forScale: self.computeScale(distanceFromCenter, minScale: cell.miniumScale));
            }
        }
    }
    
    private func computeDistanceFromCenter(indexPath:NSIndexPath) -> CGFloat {
        let cellRect = self.rectForRowAtIndexPath(indexPath);
        let cellCenter = cellRect.origin.y + cellRect.size.height/2;
        let contentCenter = self.contentOffset.y + self.bounds.size.height/2;
        
        return fabs(cellCenter - contentCenter);
    }
    
    private func computeScale(distanceFromCenter:CGFloat, minScale:CGFloat)->CGFloat {
        return  (1.0 - minScale) * distanceFromCenter / self.bounds.size.height;
    }

}
