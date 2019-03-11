//
//  ULiveGiftOperation.swift
//  UUStudent
//
//  Created by Asun on 2019/1/18.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

class AsunGiftOperation: Operation {

    var imageStr:String?

    var giftView:AsunGiftView?

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

    convenience init(gift:AsunGiftView,imageStr:String) {
        self.init()
        self.giftView = gift
        self.imageStr = imageStr


        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

    }

    @objc func becomeActive() {
        self._isFinished = true
    }

    override func start() {
        do {
            if isCancelled {
                _isFinished = true
                return
            }
            _isExecuting = true
            DispatchQueue.main.async {
                self.giftView?.showOperationView(name: self.imageStr ?? "", isfinished: { [weak self](value) in
                    guard let `self` = self else { return }
                    self._isFinished = value
                })
            }
        } catch {
            print(error)
        }
    }
}
