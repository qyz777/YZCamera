//
//  FilterManager.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/23.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import CoreImage

enum FilterStyleEffect: String, CaseIterable {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer = "CIPhotoEffectTransfer"
    
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

class FilterManager: NSObject {
    static let shared = FilterManager()
    
    private override init() {}
    
//    获得一个Effect滤镜
    func getEffectFilter(style: FilterStyleEffect, image: UIImage) -> UIImage {
        let inputImage = CIImage.init(image: image)
        let filter = CIFilter.init(name: style.rawValue)!
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        let contex = CIContext.init()
        let cgImage = contex.createCGImage(outputImage, from: outputImage.extent)
        let filterImage = UIImage.init(cgImage: cgImage!)
        return filterImage
    }
    
//    获得所有Effect滤镜
    func allEffectFilter(image: UIImage, complete: @escaping (_ array: Array<FilterModel>) -> Void) {
        var modelArray: Array<FilterModel> = []
        for effect in FilterStyleEffect.allCases {
            let model = FilterModel.init()
            let image = self.getEffectFilter(style: effect, image: image)
            model.filterImage = image
            model.title = effect.title
            modelArray.append(model)
        }
        complete(modelArray)
    }
}
