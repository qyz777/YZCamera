//
//  AlbumManager.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/24.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import Photos

class AlbumManager: NSObject {

    static let shared = AlbumManager()
    
    private override init() {}
    
//    判断有无相册权限
    func hasAuth() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.restricted || status == PHAuthorizationStatus.denied {
            return true
        }else {
            return false
        }
    }
    
//    获得所有相册
    func allAlbums(complete: @escaping (_ array: Array<AlbumModel>) -> Void) {
        var dataArray: Array<AlbumModel> = []
        let albums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
        albums.enumerateObjects { (collection, index, pointer) in
            if collection.isKind(of: PHAssetCollection.self) {
                let fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
                if fetchResult.count > 0 {
                    let asset = fetchResult.lastObject
                    let opt = PHImageRequestOptions.init()
                    opt.isSynchronous = true
                    let manager = PHImageManager.init()
                    manager.requestImageData(for: asset!, options: opt, resultHandler: { (data, dataUTI, orientation, info) in
                        let result = UIImage.init(data: data!)
                        let compressionData = result?.jpegData(compressionQuality: 0)
                        let model = AlbumModel.init()
                        model.albumName = collection.localizedTitle
                        model.firstImage = UIImage.init(data: compressionData!)
                        model.collection = collection
                        model.fetchResult = fetchResult
                        dataArray.append(model)
                    })
                }
            }
        }
        complete(dataArray)
    }
    
//    获得一个相册的所有图片
    func getImages(fetch: PHFetchResult<PHAsset>, size: CGSize, complete: @escaping (_ array: Array<UIImage>) -> Void) {
        var dataArray: Array<UIImage> = []
        autoreleasepool {
            fetch.enumerateObjects(options: NSEnumerationOptions.reverse, using: { (asset, index, pointer) in
                let opt = PHImageRequestOptions.init()
                opt.isSynchronous = true
                let manager = PHImageManager.init()
                manager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: opt, resultHandler: { (image, info) in
                    dataArray.append(image!)
                })
            })
        }
        complete(dataArray)
    }
    
//    获得原图
    func getOriginalImage(asset: PHAsset, complete: @escaping (_ image: UIImage) -> Void) {
        let opt = PHImageRequestOptions.init()
        opt.isSynchronous = true
        let manager = PHImageManager.init()
        manager.requestImage(for: asset, targetSize: CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: opt) { (image, info) in
            complete(image!)
        }
    }
    
//    获得图片
    func getImage(asset: PHAsset, size: CGSize, complete: @escaping (_ image: UIImage) -> Void) {
        let opt = PHImageRequestOptions.init()
        opt.isSynchronous = true
        let manager = PHImageManager.init()
        manager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: opt) { (image, info) in
            complete(image!)
        }
    }
    
    func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(save(image:didFinishWithError:contentInfo:)), nil)
    }
    
    @objc private func save(image: UIImage, didFinishWithError error: Error?, contentInfo: AnyObject) {
        if error != nil {
            UIApplication.shared.keyWindow?.rootViewController?.showToast(string: "保存失败")
        }else {
            UIApplication.shared.keyWindow?.rootViewController?.showToast(string: "保存成功")
        }
    }
}
