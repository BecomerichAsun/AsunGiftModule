//
//  AsunFlowLayout.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/11.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height


class AsunFlowLayout: UICollectionViewFlowLayout {

    var cellAttributeArray:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        super.prepare()
        let itemW:CGFloat = ScreenWidth/4
        let itemH:CGFloat = 135/2
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .horizontal

        if self.cellAttributeArray.count > 0 {
            self.cellAttributeArray.removeAll()
        }

        let cellCount:Int = self.collectionView?.numberOfItems(inSection: 0) ?? 0

        for item in 0..<cellCount {
            let indexpath:IndexPath = IndexPath(row: item, section: 0)
            let attibute = self.layoutAttributesForItem(at: indexpath) ?? UICollectionViewLayoutAttributes()
            let page = item / 8
            let row:CGFloat = CGFloat(item % 4 + page * 4)
            let col:CGFloat = CGFloat(item / 4 - page * 2)
            attibute.frame = CGRect(x: row*itemW, y: col*itemH, width: itemW, height: itemH)
            self.cellAttributeArray.append(attibute)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cellAttributeArray
    }


    override var collectionViewContentSize: CGSize {
        let cellCount:Int = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        let page:CGFloat = CGFloat((cellCount / 8) + 1)
        return CGSize(width: ScreenWidth*page, height: 0)
    }
}
