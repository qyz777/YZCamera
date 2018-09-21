//
//  GlobalVariable.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/21.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import Foundation
@_exported import SnapKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor { return UIColor(red: r, green: g, blue: b, alpha: 1.0) }

// 16进制
func ColorFromRGB(rgbValue: Int) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0xFF) / 255.0,
                   alpha: 1.0)
}
