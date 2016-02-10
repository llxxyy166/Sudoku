//
//  GameBoardView.swift
//  Sudoku
//
//  Created by xinye lei on 16/2/9.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

import UIKit

class GameBoardView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let origin = self.bounds.origin
        let height = self.bounds.size.height / 9
        let width = self.bounds.size.width / 9
        var count = 0
        let color = UIColor.blackColor()
        color.setStroke()
        for (var pos = origin.x; pos <= origin.x + 9 * width; pos += width) {
            let path = UIBezierPath()
            if (count % 3 == 0) {
                path.lineWidth = 3.0
            }
            else {
                path.lineWidth = 1.0
            }
            let point1 = CGPointMake(pos, origin.y)
            let point2 = CGPointMake(pos, origin.y + 9 * height)
            path.moveToPoint(point1)
            path.addLineToPoint(point2)
            path.stroke()
            count++;
        }
        count = 0;
        for (var pos = origin.y; pos <= origin.y + 9 * height; pos += height) {
            let path = UIBezierPath()
            if (count % 3 == 0) {
                path.lineWidth = 3.0
            }
            else {
                path.lineWidth = 1.0
            }
            let point1 = CGPointMake(origin.x, pos)
            let point2 = CGPointMake(origin.x + 9 * width, pos)
            path.moveToPoint(point1)
            path.addLineToPoint(point2)
            path.stroke()
            count++;
        }
    }
    
}
