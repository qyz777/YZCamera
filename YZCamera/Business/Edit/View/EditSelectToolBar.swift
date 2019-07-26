//
//  EditSelectToolBar.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/24.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

protocol EditSelectToolBarDelegate: class {
    func itemDidSelect(index: Int)
}

class EditSelectToolBar: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var yz_delegate: EditSelectToolBarDelegate?
    
    var barType: PhotoToolBarType = PhotoToolBarType.filter

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 60, height: 70)
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("fail")
    }
    
    func initView() {
        register(EditSelectToolBarCell.self, forCellWithReuseIdentifier: EditSelectToolBarCell.identifier())
        self.delegate = self
        self.dataSource = self
        backgroundColor = UIColor.white
        self.showsHorizontalScrollIndicator = false
    }
    
    var dataArray: Array<FilterModel> = [] {
        didSet {
            reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditSelectToolBarCell.identifier(), for: indexPath) as! EditSelectToolBarCell
        cell.data = dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        yz_delegate?.itemDidSelect(index: indexPath.item)
    }
}
