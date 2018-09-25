//
//  EditSliderToolBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/24.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

protocol EditSliderToolBarDelegate: class {
    func valueDidChanged(value: Float)
}

class EditSliderToolBar: UIView {
    
    weak var yz_delegate: EditSliderToolBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(slider)
        
        slider.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        yz_delegate?.valueDidChanged(value: sender.value)
    }
    
    lazy var slider: UISlider = {
        let slider = UISlider.init()
        slider.minimumValue = 0
        slider.maximumValue = 20
        slider.value = 0
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: UIControl.Event.valueChanged)
        return slider
    }()

}
