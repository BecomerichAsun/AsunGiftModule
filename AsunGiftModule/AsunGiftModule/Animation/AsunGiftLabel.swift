//
//  AsunGiftLabel.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/13.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

class AsunGiftLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let shadowOffSet = self.shadowOffset
        let textColor = self.textColor
        
        let ref = UIGraphicsGetCurrentContext()
        ref?.setLineWidth(5)
        ref?.setLineJoin(CGLineJoin.round)
        ref?.setTextDrawingMode(.fillStroke)
        self.textColor = UIColor.orange
        super.drawText(in: rect)
        
        ref?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: rect)
        
        self.shadowOffset = shadowOffSet
    }
}
