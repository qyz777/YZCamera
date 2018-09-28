//
//  UIImage+Utility.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/28.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    /// 等比缩放图片
    ///
    /// - Parameter scale: 缩放程度 scale >= 0
    /// - Returns: UIImage
    func scaleImage(scale: CGFloat) -> UIImage {
        let reSize = CGSize.init(width: self.size.width * scale, height: self.size.height * scale)
        return reSizeImage(reSize: reSize)
    }
    
    
    /// UIImage -> CGImage
    ///
    /// - Returns: CGImage
    func convertToCGImage() -> CGImage {
        let cgImage = self.cgImage
        if cgImage == nil {
            let ciImage = self.ciImage
            let ciContext = CIContext.init()
            return ciContext.createCGImage(ciImage!, from: ciImage!.extent)!
        }else {
            return cgImage!
        }
    }
    
    private func reSizeImage(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
}
