//
//  UIViewController+HUD.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import MBProgressHUD

extension YZNamespace where Base: UIViewController {
    
    var HUD: MBProgressHUD {
        get {
            return objc_getAssociatedObject(self, #function) as! MBProgressHUD
        }
        set {
            objc_setAssociatedObject(self, #function, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showToast(_ string: String) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.init(view: self.base.view)
            hud.label.text = string
            hud.show(animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
            hud.bezelView.color = UIColor.black
            hud.contentColor = UIColor.white
            hud.layer.cornerRadius = 4
            hud.hide(animated: true, afterDelay: TimeInterval.init(2))
            self.HUD = hud
        }
    }
}
