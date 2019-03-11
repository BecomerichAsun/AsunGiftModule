//
//  AsunGiftCollectionView.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/11.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

class AsunGiftCell: UICollectionViewCell {

    lazy var giftImage:UIImageView = {
        let img = UIImageView()
        img.sizeThatFits(CGSize(width: ScreenWidth/4, height: 100/2))
        img.frame = CGRect(x: 0, y: 0, width: ScreenWidth/4, height: 100/2)
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        contentView.addSubview(giftImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
