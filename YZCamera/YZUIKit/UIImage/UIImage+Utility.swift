//
//  UIImage+Utility.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/28.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

extension YZNamespace where Base: UIImage {
    
    
    /// 等比缩放图片
    ///
    /// - Parameter scale: 缩放程度 scale >= 0
    /// - Returns: UIImage
    func scaleImage(scale: CGFloat) -> UIImage {
        let reSize = CGSize.init(width: base.size.width * scale, height: base.size.height * scale)
        return reSizeImage(reSize: reSize)
    }
    
    
    /// UIImage -> CGImage
    ///
    /// - Returns: CGImage
    func convertToCGImage() -> CGImage {
        let cgImage = base.cgImage
        if cgImage == nil {
            let ciImage = base.ciImage
            let ciContext = CIContext.init()
            return ciContext.createCGImage(ciImage!, from: ciImage!.extent)!
        }else {
            return cgImage!
        }
    }
    
    private func reSizeImage(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        base.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
}
