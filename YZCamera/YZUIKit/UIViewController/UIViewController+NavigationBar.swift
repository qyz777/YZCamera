//
//  UIViewController+NavigationBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

private var key = "YZCamera.NavigationBar"

extension YZNamespace where Base: UIViewController {
    
    var navigationBar: NavigationBar {
        get {
            return objc_getAssociatedObject(base, &key) as! NavigationBar
        }
        set {
            objc_setAssociatedObject(base, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupNavigationBar() {
        base.navigationController?.navigationBar.isHidden = true
        base.yz.navigationBar = NavigationBar(frame: CGRect.zero)
        YZLog(base.yz.navigationBar)
        base.view.addSubview(base.yz.navigationBar)
        base.yz.navigationBar.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(base.view)
            make.height.equalTo(64)
        }
    }
}
