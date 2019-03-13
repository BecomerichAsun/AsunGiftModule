//
//  AsunKeyBoardView.swift
//  AsunGiftModule
//
//  Created by Asun on 2019/3/11.
//  Copyright © 2019年 Asun. All rights reserved.
//

import UIKit

protocol AsunKeyBoardDelegate:class {
    func showDetails(model:AsunGiftModel)
}

class AsunKeyBoardView: UIView {

    weak var delegate:AsunKeyBoardDelegate?

    var giftModels:[AsunGiftModel]?

    var expressionBackView:UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: ScreenHeight - (210 + (isPhoneX() ? 34 : 0)), width: ScreenWidth, height: 210 + (isPhoneX() ? 34 : 0))
        view.addCorner(roundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerSize: CGSize(width: 15, height:  15))
        view.backgroundColor = UIColor.white
        return view
    }()

    lazy var AsunGiftCollectionView:UICollectionView = {
        let col = UICollectionView(frame: CGRect.zero, collectionViewLayout: AsunFlowLayout())
        col.isPagingEnabled = true
        col.bounces = true
        col.decelerationRate = UIScrollView.DecelerationRate.fast
        col.showsHorizontalScrollIndicator = false
        col.showsVerticalScrollIndicator = false
        col.delegate = self
        col.dataSource = self
        col.backgroundColor = UIColor.white
        col.register(AsunGiftCell.self, forCellWithReuseIdentifier: "GiftCell")
        return col
    }()

    lazy var pageControl:UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.currentPageIndicatorTintColor = UIColor.red
        page.pageIndicatorTintColor = UIColor.gray
        page.hidesForSinglePage = true
        return page
    }()

    lazy var bottomView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    var deviceIndicator:CGFloat = isPhoneX() ? 34 : 0

    var colHeigh:CGFloat = 145

    override init(frame: CGRect) {
        super.init(frame: frame)
        creatDataSourceImages()
        self.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight)
    }

    func creatDataSourceImages() {
        giftModels = [AsunGiftModel]()
        for item in 0..<10 {
            let model = AsunGiftModel()
            model.defaultCount = 0
            model.giftId = "\(item)"
            model.giftKey = "\(item)" as NSString
            model.sendCount = 1
            model.giftName = "\(item)"
            model.defaultCount = 0
            self.giftModels?.append(model)
        }
        self.addSubview(expressionBackView)

        expressionBackView.addSubview(AsunGiftCollectionView)
        expressionBackView.addSubview(pageControl)

        AsunGiftCollectionView.frame = CGRect(x: 0, y:40, width: ScreenWidth, height: colHeigh)

        pageControl.frame = CGRect(x: ScreenWidth/2 - 50/2, y: (expressionBackView.bounds.size.height - 20) - 5/2, width: 50, height: 5)

        pageControl.numberOfPages = ((giftModels?.count ?? 0) / 8) + 1

        AsunGiftCollectionView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 控制表情键盘出现/隐藏
extension AsunKeyBoardView {
    func showExpression() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (viewItem) in
            if(viewItem.isKind(of: AsunKeyBoardView.self)){
                viewItem.removeFromSuperview()
            }
        })

        self.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight)

        UIApplication.shared.keyWindow?.addSubview(self)

        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        }
    }

    func hideExpressionView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x: 0, y: self.deviceIndicator + ScreenHeight + self.colHeigh, width: ScreenWidth, height: ScreenHeight)
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in:self)
        if point.y < (ScreenHeight - 210 - self.deviceIndicator) {
            self.hideExpressionView()
        }
    }
}
//MARK: Delegate/Datasource
extension AsunKeyBoardView: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCell", for: indexPath) as! AsunGiftCell
        cell.giftImage.image = UIImage(named: giftModels?[indexPath.row].giftName ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            del.showDetails(model: (self.giftModels?[indexPath.row] ?? AsunGiftModel()))
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        pageControl.currentPage = Int(x/ScreenWidth + 0.5)
    }
}
