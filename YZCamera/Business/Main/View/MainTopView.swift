//
//  MainTopView.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/21.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

@objc protocol MainTopViewDelegate: class {
//    切换前后相机
    func cameraShouldSwitch()
}

class MainTopView: UIView {
    
    weak var yz_delegate: MainTopViewDelegate?
    
    lazy var switchBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage.init(named: "main_switch_btn"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(switchBtnDidClicked), for: UIControl.Event.touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() -> Void {
        addSubview(switchBtn)
        switchBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(25)
            make.right.equalTo(-15)
        }
    }

    @objc func switchBtnDidClicked() {
        yz_delegate?.cameraShouldSwitch()
    }
}
