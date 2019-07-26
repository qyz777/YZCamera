//
//  FilterManager.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/23.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import CoreImage
import GPUImage

enum FilterStyleEffect: String, CaseIterable {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer = "CIPhotoEffectTransfer"
    case Tone = "CISepiaTone"
    case Vignette = "CIVignette"
    
    var title: String {
        switch self {
        case .Chrome: return "Chrome"
        case .Fade: return "Fade"
        case .Instant: return "Instant"
        case .Mono: return "Mono"
        case .Noir: return "Noir"
        case .Process: return "Process"
        case .Tonal: return "Tonal"
        case .Transfer: return "Transfer"
        case .Tone: return "Tone"
        case .Vignette: return "Vignette"
        }
    }
    
    static func style(index: Int) -> FilterStyleEffect {
        var i = 0
        for style in FilterStyleEffect.allCases {
            if i == index {
                return style
            }
            i += 1
        }
        return FilterStyleEffect.Chrome
    }
}

enum GPUFilterStyle: String, CaseIterable {
    case sketch = "GPUImageSketchFilter"
    case toon = "GPUImageToonFilter"
    case smoothToon = "GPUImageSmoothToonFilter"
    case emboss = "GPUImageEmbossFilter"
    case dot = "GPUImagePolkaDotFilter"
    
    var title: String {
        switch self {
        case .sketch: return "sketch"
        case .toon: return "toon"
        case .smoothToon: return "sToon"
        case .emboss: return "emboss"
        case .dot: return "dot"
        }
    }
    
    var instance: GPUImageOutput {
        let filterClass: AnyClass = NSClassFromString(self.rawValue)!
        let realClass = filterClass as! GPUImageOutput.Type
        return realClass.init()
    }
}

class FilterManager: NSObject {
    static let shared = FilterManager()
    
    private override init() {}
    
//    获得一个Effect滤镜
    func getEffectFilter(style: FilterStyleEffect, image: UIImage) -> UIImage {
        let inputImage = CIImage.init(image: image)
        let filter = CIFilter.init(name: style.rawValue)!
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        return draw(image: filter.outputImage!)
    }
    
//    获得所有Effect滤镜
    func allEffectFilter(image: UIImage, complete: @escaping (_ array: Array<FilterModel>) -> Void) {
        var modelArray: Array<FilterModel> = []
        for effect in FilterStyleEffect.allCases {
            let model = FilterModel.init()
            let image = getEffectFilter(style: effect, image: image)
            model.filterImage = image
            model.title = effect.title
            modelArray.append(model)
        }
        complete(modelArray)
    }
    
//    模糊
    func blurFilter(image: UIImage, value: Float) -> UIImage {
        let inputImage = CIImage.init(image: image)
        let filter = CIFilter.init(name: "CIGaussianBlur")!
        let number = NSNumber.init(value: value)
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(number, forKey: "inputRadius")
        return draw(image: filter.outputImage!)
    }
    
//    多项式滤镜
    func crossFilter(image: UIImage, red: Array<CGFloat>, green: Array<CGFloat>, blue: Array<CGFloat>) -> UIImage {
        let inputImage = CIImage.init(image: image)
        let filter = CIFilter.init(name: "CIColorCrossPolynomial")!
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let r = CIVector.init(values: [red[0], red[1], red[2], red[3], red[4], red[5], red[6], red[7], red[8], red[9]], count: 10)
        filter.setValue(r, forKey: "inputRedCoefficients")
        let g = CIVector.init(values: [green[0], green[1], green[2], green[3], green[4], green[5], green[6], green[7], green[8], green[9]], count: 10)
        filter.setValue(g, forKey: "inputGreenCoefficients")
        let b = CIVector.init(values: [blue[0], blue[1], blue[2], blue[3], blue[4], blue[5], blue[6], blue[7], blue[8], blue[9]], count: 10)
        filter.setValue(b, forKey: "inputBlueCoefficients")
        return draw(image: filter.outputImage!)
    }
    
//    锐化 value 0 - 1
    func sharpenFilter(image: UIImage, value: Float) -> UIImage {
        let inputImage = CIImage.init(image: image)
        let filter = CIFilter.init(name: "CISharpenLuminance")!
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(NSNumber.init(value: value), forKey: "inputSharpness")
        return draw(image: filter.outputImage!)
    }
    
//    绘制图片
    private func draw(image: CIImage) -> UIImage {
        let contex = CIContext.init()
        let cgImage = contex.createCGImage(image, from: image.extent)
        return UIImage.init(cgImage: cgImage!)
    }
}
