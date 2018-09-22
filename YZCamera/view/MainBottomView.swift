//
//  MainBottomView.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/21.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

@objc protocol MainBottomViewDelegate {
    @objc func photoBtnDidClick() -> Void
}

class MainBottomView: UIView {
    
    var yz_delegate: MainBottomViewDelegate?
    
    lazy var photoBtn: UIButton = {
        let btn = UIButton.init()
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 35;
        btn.addTarget(self, action: #selector(photoBtnDidClicked), for: UIControl.Event.touchUpInside)
        return btn;
    }()
    
    lazy var btnBottomView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: 80 / 2, y: 80 / 2), radius: 39, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        var maskLayer = CAShapeLayer.init()
        maskLayer.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = 1
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() -> Void {
        backgroundColor = ColorFromRGB(rgbValue: 0x333333)
        
        addSubview(btnBottomView)
        addSubview(photoBtn)
        
        btnBottomView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 80, height: 80))
            make.center.equalTo(self)
        }
        
        photoBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 70))
            make.center.equalTo(self)
        }
    }
    
    @objc func photoBtnDidClicked() -> Void {
        yz_delegate?.photoBtnDidClick()
    }
}