//
//  UIViewController+KEY.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

// 存放extension UIViewController关联需要的KEY
extension UIViewController {
    struct RuntimeKey {
        static let navigationBarKey = UnsafeRawPointer.init(bitPattern: "YZCamera.navigationBar".hashValue)
        static let HUDKey = UnsafeRawPointer.init(bitPattern: "YZCamera.hud".hashValue)
    }
}
