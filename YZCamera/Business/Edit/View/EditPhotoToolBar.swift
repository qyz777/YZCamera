//
//  EditPhotoToolBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/23.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

enum PhotoToolBarType: Int {
    case filter
    case blur
    case cross
    case sharpen
}

protocol EditPhotoToolBarDelegate: class {
    func didSelectToolItem(type: PhotoToolBarType);
}

class EditPhotoToolBar: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dataArray: Array<[String : String]> = []
    
    var lastIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    
    weak var yz_delegate: EditPhotoToolBarDelegate?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 60, height: 70)
        layout.minimumInteritemSpacing = 15
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        delegate = self
        dataSource = self
        self.backgroundColor = UIColor.white
        register(EditPhotoToolBarCell.self, forCellWithReuseIdentifier: EditPhotoToolBarCell.identifier())
        dataArray = [["image": "edit_bar_filter", "title": "滤镜"],
                     ["image": "edit_bar_blur", "title": "模糊"],
                     ["image": "edit_bar_cross", "title": "色彩"],
                     ["image": "edit_bar_sharpen", "title": "锐化"]]
        reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPhotoToolBarCell.identifier(), for: indexPath) as! EditPhotoToolBarCell
        cell.data = dataArray[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != lastIndexPath.item else {
            setCellState(indexPath: indexPath, selected: true, isSelf: true)
            return
        }
        setCellState(indexPath: lastIndexPath, selected: false)
        setCellState(indexPath: indexPath, selected: true)
        yz_delegate?.didSelectToolItem(type: PhotoToolBarType(rawValue: indexPath.item)!)
        lastIndexPath = indexPath
    }
    
    func setCellState(indexPath: IndexPath, selected: Bool, isSelf: Bool = false) {
        let cell = self.cellForItem(at: indexPath) as! EditPhotoToolBarCell
        if isSelf == true {
            cell.isPitch = !cell.isPitch
            if cell.isPitch == true {
                yz_delegate?.didSelectToolItem(type: PhotoToolBarType(rawValue: indexPath.item)!)
            }
        }else {
            cell.isPitch = selected
        }
    }
}
