//
//  EditPhotoViewController.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/23.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import Photos
import AudioToolbox

class EditPhotoViewController: UIViewController {
    
    var startCenter: CGPoint = CGPoint.zero
    var startFrame: CGRect = CGRect.zero
    
    var startImageViewCenter: CGPoint = CGPoint.zero
    var startImageViewSize: CGSize = CGSize.zero
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(center: CGPoint, frame: CGRect) {
        self.init(nibName: nil, bundle: nil)
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        startCenter = CGPoint.init(x: center.x, y: center.y + 64)
        startFrame = frame
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.init(white: 1, alpha: 1)
            self.imageView.frame = CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 80 - 64)
            self.imageView.center = CGPoint.init(x: SCREEN_WIDTH / 2, y: 64 + (SCREEN_HEIGHT - 80 - 64) / 2)
        }) { (complete) in
            self.startImageViewCenter = self.imageView.center
            self.startImageViewSize = self.imageView.frame.size
        }
    }
    
    func initView() {
        navigationBar()
        yz_navigationBar?.leftBtn.setImage(UIImage.init(named: "back_btn"), for: UIControl.State.normal)
        yz_navigationBar?.leftBtn.addTarget(self, action: #selector(backBtnDidClicked), for: UIControl.Event.touchUpInside)
        yz_navigationBar?.titleLabel.text = "编辑"
        yz_navigationBar?.layer.zPosition = 99
        view.addSubview(imageView)
        imageView.frame = startFrame
        imageView.center = startCenter
        
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(imageViewOnPinch(pinch:)))
        view.addGestureRecognizer(pinch)
    }
    
    var asset: PHAsset? {
        willSet {
            let opt = PHImageRequestOptions.init()
            opt.isSynchronous = true
            let manager = PHImageManager.init()
            manager.requestImage(for: newValue!, targetSize: CGSize.init(width: newValue!.pixelWidth, height: newValue!.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: opt) { (image, info) in
                self.imageView.image = image
            }
        }
    }
    
    @objc func backBtnDidClicked() {
        dismiss(animated: true, completion: nil)
    }
    
//    下拉退出手势
    @objc func imageViewOnPan(pan: UIPanGestureRecognizer) {
        if pan.state == UIPanGestureRecognizer.State.changed {
            let point = pan.translation(in: imageView)
            let offsetY = point.y
            if offsetY > 0 {
                let newCenter = CGPoint.init(x: startImageViewCenter.x + point.x, y: startImageViewCenter.y + point.y)
                imageView.center = newCenter
                let minScale: CGFloat = 0.5
                let newScale = (imageView.frame.size.height - abs(offsetY) * 0.5) / imageView.frame.size.height
                view.backgroundColor = UIColor.init(white: 1, alpha: newScale)
                if newScale > minScale {
                    imageView.frame.size = CGSize.init(width: startImageViewSize.width * newScale, height: startImageViewSize.height * newScale)
                }
            }
        }else if pan.state == UIPanGestureRecognizer.State.ended {
            let scale = imageView.frame.size.height / startImageViewSize.height
            if scale <= 0.80 {
                self.view.backgroundColor = UIColor.init(white: 1, alpha: 0)
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.frame = self.startFrame
                    self.imageView.center = self.startCenter
                }) { (complete) in
                    self.dismiss(animated: false, completion: nil)
                }
            }else {
                UIView.animate(withDuration: 0.2) {
                    self.view.backgroundColor = UIColor.init(white: 1, alpha: 1)
                    self.imageView.frame = CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 80 - 64)
                    self.imageView.center = self.startImageViewCenter
                }
            }
        }
    }
    
    @objc func imageViewOnPinch(pinch: UIPinchGestureRecognizer) {
        if pinch.state == UIPinchGestureRecognizer.State.changed {
            imageView.transform = CGAffineTransform.init(scaleX: 1 * pinch.scale, y: 1 * pinch.scale)
        }else if pinch.state == UIPinchGestureRecognizer.State.ended {
            if pinch.scale > 1.5 {
                imageView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            }
            
            if pinch.scale < 1.0 {
                imageView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                AudioServicesPlaySystemSound(1519);
            }
        }
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.clipsToBounds = true
        view.contentMode = UIImageView.ContentMode.scaleAspectFill
        view.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(imageViewOnPan(pan:)))
        view.addGestureRecognizer(pan)
        return view
    }()
}
