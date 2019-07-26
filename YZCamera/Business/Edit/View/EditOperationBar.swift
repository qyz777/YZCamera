//
//  EditOperationBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/24.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

@objc protocol EditOperationBarDelegate: class {
    @objc func imageShouldChange(isSave: Bool)
}

class EditOperationBar: UIView {
    
    weak var yz_delegate: EditOperationBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(okBtn)
        addSubview(cancelBtn)
        
        okBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("fail")
    }
    
    @objc func okBtnDidClicked() {
        yz_delegate?.imageShouldChange(isSave: true)
    }
    
    @objc func cancelBtnDidClicked() {
        yz_delegate?.imageShouldChange(isSave: false)
    }
    
    lazy var okBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage.init(named: "edit_ok_btn"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(okBtnDidClicked), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage.init(named: "edit_cancel_btn"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(cancelBtnDidClicked), for: UIControl.Event.touchUpInside)
        return btn
    }()
}
