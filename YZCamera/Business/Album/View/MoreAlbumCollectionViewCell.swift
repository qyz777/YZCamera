//
//  MoreAlbumCollectionViewCell.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/23.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class MoreAlbumCollectionViewCell: UICollectionViewCell {
    
    class func identifier() -> String {
        return NSStringFromClass(MoreAlbumCollectionViewCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var image: UIImage? {
        willSet {
            imageView.image = newValue
            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.clipsToBounds = true
        view.contentMode = UIImageView.ContentMode.scaleAspectFill
        view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
        return view
    }()
}
