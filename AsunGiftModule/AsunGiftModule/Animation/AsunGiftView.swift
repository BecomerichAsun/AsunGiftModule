//
//  ULiveGiftView.swift
//  UUStudent
//
//  Created by Asun on 2018/12/18.
//  Copyright © 2018年 bike. All rights reserved.
//

import UIKit

class AsunGiftView: UIView {

    lazy var backGroundView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        return view
    }()

    lazy var contentLabel:UILabel = {
        let lab = UILabel()
        lab.text = "Asun 给帅气阿日送了一个"
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.numberOfLines = 1
        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setNormalAttribute()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AsunGiftView {
    func setNormalAttribute() {
        self.backgroundColor = UIColor.clear
        self.addSubview(backGroundView)
        backGroundView.frame = CGRect(x: 2, y: 50, width: 220, height: 30)
        backGroundView.addCorner(roundingCorners: [UIRectCorner.bottomRight,UIRectCorner.topRight], cornerSize: CGSize(width: 15, height: 15))
        backGroundView.addSubview(contentLabel)
        contentLabel.frame = CGRect(x: 2, y: backGroundView.bounds.size.height/2 - 10/2, width: 150, height: 10)
        self.isOpaque = false
        self.isHidden = true
    }
    // 动画展示
    func showOperationView(name:String,isfinished:@escaping ((Bool) -> ())) {
        let giftView = UIImageView()
        giftView.image = UIImage(named: name)
        self.addSubview(giftView)
        giftView.frame = CGRect(x: 148, y: 0, width: 80, height: 80)
        self.isHidden = false
        self.transform = CGAffineTransform.init(translationX: -self.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            giftView.removeFromSuperview()
            self.alpha = 0
            self.transform = CGAffineTransform.init(translationX: -self.frame.size.width, y: 0)
            self.alpha = 1
            isfinished(true)
        }
    }
}
