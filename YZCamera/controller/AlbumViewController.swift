//
//  AlbumViewController.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var assets: Array<PHAsset> = []
    
    var dataArray: Array<AlbumModel> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        initView()
        loadImage()
    }
    
    func initView() {
        view.backgroundColor = UIColor.white
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier())
        view.addSubview(collectionView)
        yz_navigationBar?.leftBtn.setImage(UIImage.init(named: "back_btn"), for: UIControl.State.normal)
        yz_navigationBar?.leftBtn.addTarget(self, action: #selector(backBtnDidClicked), for: UIControl.Event.touchUpInside)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(yz_navigationBar!.snp.bottom)
            make.right.left.bottom.equalTo(view)
        }
    }
    
    @objc func backBtnDidClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadImage() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.restricted || status == PHAuthorizationStatus.denied {
            userShouldOpenAuth()
        }else {
            collectionView.alpha = 0
            DispatchQueue.global().async {
                self.allAlbums(complete: {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        UIView.animate(withDuration: 0.4, animations: {
                            self.collectionView.alpha = 1
                        })
                    }
                })
            }
        }
    }
    
    private func allAssetsInPhotoAlbum() {
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let result = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
        result.enumerateObjects { (asset, index, pointer) in
            self.assets.append(asset)
        }
    }
    
    private func allAlbums(complete: () -> Void) {
        let albums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        albums.enumerateObjects { (collection, index, pointer) in
            if collection.isKind(of: PHAssetCollection.self) {
                let fetchResult = PHAsset.fetchKeyAssets(in: collection, options: nil)
                if (fetchResult?.count)! > 0 {
                    let asset = fetchResult?.firstObject
                    let opt = PHImageRequestOptions.init()
                    opt.isSynchronous = true
                    let manager = PHImageManager.init()
                    manager.requestImage(for: asset!, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFill, options: opt, resultHandler: { (result, info) in
                        let model = AlbumModel.init()
                        model.albumName = collection.localizedTitle
                        model.firstImage = result ?? UIImage.init(named: "album_default_album")
                        self.dataArray.append(model)
                    })
                }
            }
        }
        complete()
    }
    
    private func userShouldOpenAuth() {
        let alert = UIAlertController.init(title: "提示", message: "此APP需要您打开相册权限", preferredStyle: UIAlertController.Style.alert)
        
        let goAction = UIAlertAction.init(title: "去开启", style: UIAlertAction.Style.default) { (alert) in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : true], completionHandler: nil)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(goAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier(), for: indexPath)  as! AlbumCollectionViewCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    // MARK: lazy
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: (SCREEN_WIDTH - 40) / 2, height: (SCREEN_WIDTH - 40) / 2 + 35)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 15, right: 15)
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.dataSource = self
        view.delegate = self
        return view
    }()
}
