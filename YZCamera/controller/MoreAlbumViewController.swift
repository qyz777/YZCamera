//
//  MoreAlbumViewController.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/23.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import Photos

class MoreAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dataArray: Array<UIImage> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        navigationBar()
        yz_navigationBar?.leftBtn.setImage(UIImage.init(named: "back_btn"), for: UIControl.State.normal)
        yz_navigationBar?.leftBtn.addTarget(self, action: #selector(backBtnDidClicked), for: UIControl.Event.touchUpInside)
        yz_navigationBar?.titleLabel.text = model?.albumName
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(yz_navigationBar?.snp.bottom ?? view.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
        collectionView.register(MoreAlbumCollectionViewCell.self, forCellWithReuseIdentifier: MoreAlbumCollectionViewCell.identifier())
    }
    
    var model: AlbumModel? {
        willSet {
            DispatchQueue.global().async {
                autoreleasepool {
                    newValue?.fetchResult?.enumerateObjects(options: NSEnumerationOptions.reverse, using: { (asset, index, pointer) in
                        let opt = PHImageRequestOptions.init()
                        opt.isSynchronous = true
                        let manager = PHImageManager.init()
                        manager.requestImage(for: asset, targetSize: CGSize.init(width: (SCREEN_WIDTH / 4) - 4, height: (SCREEN_WIDTH / 4) - 4), contentMode: PHImageContentMode.aspectFill, options: opt, resultHandler: { (image, info) in
                            self.dataArray.append(image!)
                        })
                    })
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func backBtnDidClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreAlbumCollectionViewCell.identifier(), for: indexPath) as! MoreAlbumCollectionViewCell
        cell.image = dataArray[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MoreAlbumCollectionViewCell
        let vc = EditPhotoViewController.init(center: cell.center, frame: cell.frame)
        vc.asset = model?.fetchResult![(model?.fetchResult?.count)! - indexPath.item - 1]
        present(vc, animated: false, completion: nil)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: (SCREEN_WIDTH / 4) - 4, height: (SCREEN_WIDTH / 4) - 4)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.dataSource = self
        return view
    }()
}
