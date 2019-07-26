//
//  AlbumModel.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import Photos

class AlbumModel {
    var albumName: String?
    var firstImage: UIImage?
    var collection: PHAssetCollection?
    var fetchResult: PHFetchResult<PHAsset>?
}
