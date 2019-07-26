//
//  EditSelectToolBarCell.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/24.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class EditSelectToolBarCell: UICollectionViewCell {
    
    class func identifier() -> String {
        return NSStringFromClass(EditSelectToolBarCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom)
            make.left.right.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("fail")
    }
    
    var data: FilterModel? {
        willSet {
            imageView.image = newValue?.filterImage
            titleLabel.text = newValue?.title
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.layer.cornerRadius = 8
        view.contentMode = UIImageView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = ColorFromRGB(rgbValue: 0x333333)
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
}
