//
//  AlbumCollectionViewCell.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    class func identifier() -> String {
        return NSStringFromClass(AlbumCollectionViewCell.self)
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
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
            make.width.height.equalTo((SCREEN_WIDTH - 40) / 2)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(contentView)
        }
    }
    
    var model: AlbumModel? {
        willSet {
            imageView.image = newValue?.firstImage
            titleLabel.text = newValue?.albumName
        }
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
            }) { (complete) in
                self.imageView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = UIImageView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = ColorFromRGB(rgbValue: 0xa8a8a8)
        view.layer.cornerRadius = 8
        view.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.textColor = ColorFromRGB(rgbValue: 0x333333)
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
}
