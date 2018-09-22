//
//  SaveViewController.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() -> Void {
        view.backgroundColor = UIColor.white
        view.addSubview(showImageView)
        view.addSubview(bottomView)
        bottomView.addSubview(saveBtn)
        bottomView.addSubview(backBtn)
        bottomView.addSubview(toolBtn)
        
        showImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(SCREEN_HEIGHT - 180)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(showImageView.snp.bottom)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.center.equalTo(bottomView)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.centerY.equalTo(saveBtn)
        }
        
        toolBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-30)
            make.centerY.equalTo(saveBtn)
        }
    }
    
    var imageData: Data? {
        willSet {
            let image = UIImage.init(data: newValue!)
            showImageView.image = image
        }
    }
    
    @objc func saveBtnDidClicked() {
        UIImageWriteToSavedPhotosAlbum(showImageView.image!, self, #selector(save(image:didFinishWithError:contentInfo:)), nil)
    }
    
    @objc func backBtnDidClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func toolBtnDidClicked() {
        
    }
    
    @objc func save(image: UIImage, didFinishWithError error: Error?, contentInfo: AnyObject) {
        if error != nil {
            showToast(string: "保存失败")
        }else {
            showToast(string: "保存成功")
        }
    }
    
    // MARK: lazy
    lazy var showImageView: UIImageView = {
        let image = UIImageView.init()
        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFill
        return image
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage.init(named: "save_save_btn"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(saveBtnDidClicked), for: UIControl.Event.touchUpInside)
        return btn
    }()

    lazy var backBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage.init(named: "save_back_btn"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(backBtnDidClicked), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var toolBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage.init(named: "save_tool_btn"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(toolBtnDidClicked), for: UIControl.Event.touchUpInside)
        return btn
    }()
}
