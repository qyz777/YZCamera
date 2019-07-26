//
//  MainFilterView.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/25.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class MainFilterView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 100, height: 180)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("fail")
    }

    func initSubviews() {
        register(MainFilterViewCell.self, forCellWithReuseIdentifier: MainFilterViewCell.identifier())
        backgroundColor = ColorFromRGB(rgbValue: 0x333333)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainFilterViewCell.identifier(), for: indexPath) as! MainFilterViewCell
        cell.model = dataArray[indexPath.item]
        return cell
    }
}
