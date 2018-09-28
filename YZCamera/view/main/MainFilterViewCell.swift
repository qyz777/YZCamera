//
//  MainFilterViewCell.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/26.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class MainFilterViewCell: UICollectionViewCell {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    class func identifier() -> String {
        return NSStringFromClass(MainFilterViewCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("fail")
    }
    
    var model: FilterModel? {
        willSet {
            imageView.image = newValue?.filterImage
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = UIImageView.ContentMode.scaleAspectFill
        view.layer.cornerRadius =  8
        return view
    }()
}
