//
//  YZNavigationBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class YZNavigationBar: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(leftBtn)
        addSubview(titleLabel)
        
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var leftBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
}