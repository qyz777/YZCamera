//
//  EditCrossToolBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

protocol EditCrossToolBarDelegate: class {
    func crossValueDidChange(red: Array<CGFloat>, green: Array<CGFloat>, blue: Array<CGFloat>)
}

class EditCrossToolBar: UIView {
    
    weak var yz_delegate: EditCrossToolBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(redSlider)
        addSubview(greenSlider)
        addSubview(blueSlider)
        
        redSlider.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH / 3 - 30)
        }
        
        greenSlider.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH / 3 - 30)
        }
        
        blueSlider.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH / 3 - 30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func sliderDidSlide(slider: UISlider) {
        var red: Array<CGFloat> = []
        var green: Array<CGFloat> = []
        var blue: Array<CGFloat> = []
        for i in 0...9 {
            if i < Int(redSlider.value) {
                red.append(1)
            }else {
                red.append(0)
            }
            
            if i < Int(greenSlider.value) {
                green.append(1)
            }else {
                green.append(0)
            }
            
            if i < Int(blueSlider.value) {
                blue.append(1)
            }else {
                blue.append(0)
            }
        }
        yz_delegate?.crossValueDidChange(red: red, green: green, blue: blue)
    }
    
    lazy var redSlider: UISlider = {
        let slider = UISlider.init()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.tag = 0
        slider.addTarget(self, action: #selector(sliderDidSlide(slider:)), for: UIControl.Event.valueChanged)
        return slider
    }()
    
    lazy var greenSlider: UISlider = {
        let slider = UISlider.init()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.tag = 1
        slider.addTarget(self, action: #selector(sliderDidSlide(slider:)), for: UIControl.Event.valueChanged)
        return slider
    }()
    
    lazy var blueSlider: UISlider = {
        let slider = UISlider.init()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.tag = 2
        slider.addTarget(self, action: #selector(sliderDidSlide(slider:)), for: UIControl.Event.valueChanged)
        return slider
    }()
}
