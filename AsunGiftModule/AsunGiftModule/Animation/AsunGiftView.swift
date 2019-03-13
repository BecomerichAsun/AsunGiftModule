//
//  ULiveGiftView.swift
//  UUStudent
//
//  Created by Asun on 2018/12/18.
//  Copyright © 2018年 bike. All rights reserved.
//

import UIKit

typealias showViewKeyBlock = (AsunGiftModel)->()
public typealias animationFinished = (Bool,String)->()
public typealias completeBlock = (Bool)->()

class AsunGiftView: UIView {

    var giftCount:Int = 0 {
        willSet {
            self.currentGiftCount += 1
            self.countLabel.text = "x\(self.currentGiftCount)"
            if self.currentGiftCount > 1 {
                self.setGiftCountAnimation(gift: self.countLabel)
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hiddenGiftShowView), object: nil)
                self.perform(#selector(hiddenGiftShowView), with: nil, afterDelay: TimeInterval(animationTime))
            } else {
                self.perform(#selector(hiddenGiftShowView), with: nil, afterDelay: TimeInterval(animationTime))
            }
        }
    }

    lazy var currentGiftCount:Int = 0

    lazy var animationTime:Int = 3

    lazy var giftModel:AsunGiftModel = AsunGiftModel()

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

    lazy var giftView:UIImageView = {
        let imageView = UIImageView()
        imageView.sizeThatFits(CGSize(width: 60, height: 60))
        return imageView
    }()

    lazy var countLabel:AsunGiftLabel = {
        let lab = AsunGiftLabel()
        lab.text = ""
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.numberOfLines = 1
        return lab
    }()

    var giftEndCallBack:((Bool,String) -> ())? = nil

    var giftKeyCallBack:((AsunGiftModel) -> ())? = nil

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
        self.isOpaque = false
        self.isHidden = true

        self.addSubview(backGroundView)
        backGroundView.addSubview(contentLabel)
        self.addSubview(giftView)
        self.addSubview(countLabel)

        backGroundView.frame = CGRect(x: 2, y: 50, width: 220, height: 30)
        backGroundView.addCorner(roundingCorners: [UIRectCorner.bottomRight,UIRectCorner.topRight], cornerSize: CGSize(width: 15, height: 15))
        contentLabel.frame = CGRect(x: 2, y: backGroundView.bounds.size.height/2 - 10/2, width: 150, height: 10)
        giftView.frame = CGRect(x: 148, y: 0, width: 80, height: 80)
        countLabel.frame = CGRect(x: 225, y: 50, width: 50, height: 30)
    }

    // 动画展示
    func showOperationView(giftModel:AsunGiftModel,isfinished:animationFinished? = nil) {
        self.giftModel = giftModel
        self.giftEndCallBack = isfinished
        giftView.image = UIImage(named: giftModel.giftName )
        self.isHidden = false
        if let callBack = giftKeyCallBack,self.currentGiftCount == 0 {
              callBack(giftModel)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }) { (finished) in
            self.currentGiftCount = 0
            self.giftCount = giftModel.defaultCount
        }
    }

    @objc func hiddenGiftShowView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: -self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }) { [weak self] (finished) in
            guard let `self` = self else { return }
            if let callBack = self.giftEndCallBack {
                callBack(true,self.giftModel.giftKey as String )
                self.giftModel = AsunGiftModel()
            }
            self.frame = CGRect(x: -self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            self.isHidden = true
            self.currentGiftCount = 0
            self.countLabel.text = ""
        }
    }

    private func setGiftCountAnimation(gift:UIView) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.duration = 0.08
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = 1.0
        pulse.toValue = 1.5
        gift.layer.add(pulse, forKey: "")
    }
}
