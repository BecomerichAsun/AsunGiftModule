//
//  AsunGiftManager.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/13.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit
import Foundation

class AsunGiftManager: NSObject {

    let giftMaxCount:Int = 99

    lazy var giftQueue1:OperationQueue = {
        let op = OperationQueue()
        op.maxConcurrentOperationCount = 1
        return op
    }()

    lazy var giftQueue2:OperationQueue = {
        let op = OperationQueue()
        op.maxConcurrentOperationCount = 1
        return op
    }()

    lazy var topAnimationView:AsunGiftView = {
        let view = AsunGiftView(frame: CGRect(x: -220, y: ScreenHeight - 420, width: 240, height: 80))
        return view
    }()

    lazy var bottomAnimationView:AsunGiftView = {
        let view = AsunGiftView(frame: CGRect(x: -220, y: ScreenHeight - 500, width: 240, height: 80))
        return view
    }()

    var operationCache:NSCache<NSString,Operation> = NSCache<NSString, Operation>.init()

    lazy var giftKeys:[String] = [String]()

    var finishedCallBack:completeBlock? = nil

    static let sharedManager = AsunGiftManager()

    override init() {
        super.init()
        
        topAnimationView.giftKeyCallBack = { [weak self] model in
            guard let `self` = self else { return }
            self.giftKeys.append(model.giftKey as String)
        }

        bottomAnimationView.giftKeyCallBack = { [weak self] model in
            guard let `self` = self else { return }
            self.giftKeys.append(model.giftKey as String)
        }
    }

    func showGiftView(atView:UIView,info:AsunGiftModel,completeBlock:completeBlock) {
        let key = info.giftKey as String
        let nsKey = info.giftKey
        //        如果存在
        if self.giftKeys.count > 0 && 
            (self.giftKeys.contains(key))
        {
            if (self.operationCache.object(forKey: nsKey) != nil) {
                let op:AsunGiftOperation = self.operationCache.object(forKey: nsKey) as! AsunGiftOperation

                if op.giftView?.currentGiftCount ?? 0 >= giftMaxCount {
                    self.operationCache.removeObject(forKey: nsKey)
                    for item in 0 ..< self.giftKeys.count {
                        if giftKeys[item].elementsEqual(key) {
                            self.giftKeys.remove(at: item)
                        }
                    }
                } else {
                    op.giftView?.giftCount = info.sendCount
                }
            } else {
                let queue:OperationQueue
                let animationView:AsunGiftView
                if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
                    queue = self.giftQueue1
                    animationView = self.topAnimationView
                } else {
                    queue = self.giftQueue2
                    animationView = self.bottomAnimationView
                }

                let operation = AsunGiftOperation.addOperationShowGift(giftView: animationView, atView: atView, data: info) { [weak self] (finished, giftKey) in
                    guard let `self` = self else { return }

                    if let callBack = self.finishedCallBack {
                        callBack(finished)
                    }
                    self.operationCache.removeObject(forKey: nsKey)
                    for item in 0 ..< self.giftKeys.count {
                        if self.giftKeys[item].elementsEqual(key) {
                            self.giftKeys.remove(at: item)
                        }
                    }
                }
                operation.dataSource?.defaultCount += info.sendCount
                self.operationCache.setObject(operation, forKey: nsKey)
                queue.addOperation(operation)
            }
        } else {
            if ((self.operationCache.object(forKey: nsKey)) != nil) {
                let op:AsunGiftOperation = self.operationCache.object(forKey: nsKey) as! AsunGiftOperation
                if op.giftView?.currentGiftCount ?? 0 >= giftMaxCount {
                    self.operationCache.removeObject(forKey: nsKey)
                    for item in 0 ..< self.giftKeys.count {
                        if giftKeys[item].elementsEqual(key) {
                            self.giftKeys.remove(at: item)
                        }
                    }
                } else {
                    op.dataSource?.defaultCount += info.sendCount
                }
            } else {
                let queue:OperationQueue
                let animationView:AsunGiftView
                if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
                    queue = self.giftQueue1
                    animationView = self.topAnimationView
                } else {
                    queue = self.giftQueue2
                    animationView = self.bottomAnimationView
                }

                let operation = AsunGiftOperation.addOperationShowGift(giftView: animationView, atView: atView, data: info) { [weak self] (finished, giftKey) in
                    guard let `self` = self else { return }

                    if let callBack = self.finishedCallBack {
                        callBack(finished)
                    }
                    if self.topAnimationView.giftModel.giftKey.isEqual(to: self.bottomAnimationView.giftModel.giftKey as String) {
                        return
                    }

                    self.operationCache.removeObject(forKey: nsKey)
                    for item in 0 ..< self.giftKeys.count {
                        if self.giftKeys[item] == key {
                            self.giftKeys.remove(at: item)
                        }
                    }
                }
                operation.dataSource?.defaultCount += info.sendCount
                self.operationCache.setObject(operation, forKey: nsKey)
                queue.addOperation(operation)
            }
        }
    }

}
