//
//  ViewController.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/11.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showExpression))
        self.view.addGestureRecognizer(tap)
    }
}

extension ViewController:AsunKeyBoardDelegate {
    func showDetails(model: AsunGiftModel) {
        //   调用
        AsunGiftManager.sharedManager.showGiftView(atView: self.view, info: model) { (finished) in
            if finished {
                // ....
            }
        }
    }

    //弹出键盘
    @objc func showExpression() {
        let keyBoardView:AsunKeyBoardView = AsunKeyBoardView()
        keyBoardView.delegate = self
        keyBoardView.showExpression()
    }
}

