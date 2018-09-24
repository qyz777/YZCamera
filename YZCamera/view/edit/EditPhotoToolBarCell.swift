//
//  EditPhotoToolBarCell.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/23.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class EditPhotoToolBarCell: UICollectionViewCell {
    
    class func identifier() -> String {
        return NSStringFromClass(EditPhotoToolBarCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
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
    
    var data: [String : String]? {
        willSet {
            imageView.image = UIImage.init(named: newValue!["image"]!)
            titleLabel.text = newValue!["title"]
        }
    }
    
    var isPitch: Bool = false {
        willSet {
            imageView.image = newValue == true ? UIImage.init(named: data!["select_image"]!) : UIImage.init(named: data!["image"]!)
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = UIImageView.ContentMode.center
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
