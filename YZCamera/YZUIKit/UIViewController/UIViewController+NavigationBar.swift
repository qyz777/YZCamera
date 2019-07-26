//
//  UIViewController+NavigationBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

extension YZNamespace where Base: UIViewController {
    
    var navigationBar: NavigationBar {
        get {
            return objc_getAssociatedObject(self, #function) as! NavigationBar
        }
        set {
            objc_setAssociatedObject(self, #function, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupNavigationBar() {
        base.navigationController?.navigationBar.isHidden = true
        navigationBar = NavigationBar(frame: CGRect.zero)
        base.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(base.view)
            make.height.equalTo(64)
        }
    }
}
