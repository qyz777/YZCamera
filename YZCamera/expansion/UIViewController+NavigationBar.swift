//
//  UIViewController+NavigationBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var yz_navigationBar: YZNavigationBar? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.navigationBarKey!) as? YZNavigationBar
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.navigationBarKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func navigationBar() {
        navigationController?.navigationBar.isHidden = true
        yz_navigationBar = YZNavigationBar.init(frame: CGRect.zero)
        view.addSubview(yz_navigationBar!)
        yz_navigationBar!.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(view)
            make.height.equalTo(64)
        }
    }
}
