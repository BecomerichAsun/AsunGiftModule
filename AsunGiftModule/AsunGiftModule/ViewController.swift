//
//  ViewController.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/11.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var operation:OperationQueue = {
        let op = OperationQueue()
        op.maxConcurrentOperationCount = 1
        return op
    }()

    lazy var animationView:AsunGiftView = {
        let view = AsunGiftView()
        view.frame = CGRect(x: 0, y: ScreenHeight - 350, width: 240, height: 80)
        view.backgroundColor = UIColor.clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showExpression))
        self.view.addGestureRecognizer(tap)
        self.view.addSubview(animationView)
    }
}

extension ViewController:AsunKeyBoardDelegate {
    //展示动画
    func showDetails(imageName: String) {
        let gift = AsunGiftOperation(gift: self.animationView, imageStr: imageName)
        self.operation.addOperation(gift)
    }
    //弹出键盘
    @objc func showExpression() {
        let keyBoardView:AsunKeyBoardView = AsunKeyBoardView()
        keyBoardView.delegate = self
        keyBoardView.showExpression()
    }
}

