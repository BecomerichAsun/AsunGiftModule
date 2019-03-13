//
//  ULiveGiftOperation.swift
//  UUStudent
//
//  Created by Asun on 2019/1/18.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

class AsunGiftOperation: Operation {

    var dataSource:AsunGiftModel?

    var giftView:AsunGiftView?

    var atView:UIView?

    var operationEndCallBack:((Bool,String) -> ())? = nil

    override var isExecuting: Bool {
        return _isExecuting
    }

    override var isFinished: Bool {
        return _isFinished
    }

    private var _isExecuting: Bool {
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }

    private var _isFinished: Bool {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }

    override init() {
        _isExecuting = false
        _isFinished = false
    }


    class func addOperationShowGift(giftView:AsunGiftView,atView:UIView,data:AsunGiftModel,completeCallBack:@escaping animationFinished) -> AsunGiftOperation{
        let op = AsunGiftOperation()
        op.giftView = giftView
        op.dataSource = data
        op.atView = atView
        op.operationEndCallBack = completeCallBack
        return op
    }

    override func start() {
        if isCancelled {
            _isFinished = true
            return
        }
        _isExecuting = true
        OperationQueue.main.addOperation {
            self.atView?.addSubview(self.giftView ?? AsunGiftView())
            self.giftView?.showOperationView(giftModel: self.dataSource ?? AsunGiftModel(), isfinished: { [weak self](value,key) in
                guard let `self` = self else { return }
                self._isFinished = value
                if let callBack = self.operationEndCallBack {
                    callBack(value,key)
                }
            })
        }
    }
}
