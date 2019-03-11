//
//  AsunTool.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/11.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit
import Foundation

public func isPhoneX() -> Bool {
    if UIApplication.shared.statusBarFrame.height == 44{
        return true
    }
    return false
}

extension UIView {
    public func addCorner(roundingCorners: UIRectCorner, cornerSize: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
}
