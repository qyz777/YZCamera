//
//  UIViewController+HUD.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

let keyWindow = UIApplication.shared.keyWindow

private let HUDKey = "yzcamera.hud"

extension UIViewController {
    
    var HUD: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, HUDKey) as? MBProgressHUD
        }
        set {
            objc_setAssociatedObject(self, HUDKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showToast(string: String) {
        let hud = MBProgressHUD.init(view: keyWindow!)
        keyWindow?.addSubview(hud)
        hud.label.text = string
        DispatchQueue.main.async {
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
