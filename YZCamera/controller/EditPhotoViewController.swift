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

class EditPhotoViewController: UIViewController,
    EditPhotoToolBarDelegate,
    EditSelectToolBarDelegate,
    EditOperationBarDelegate,
    EditSliderToolBarDelegate,
    EditCrossToolBarDelegate
{
    
    var startCenter: CGPoint = CGPoint.zero
    var startFrame: CGRect = CGRect.zero
    
    var startImageViewCenter: CGPoint = CGPoint.zero
    var startImageViewSize: CGSize = CGSize.zero
    
    var originalImage: UIImage = UIImage.init()
    
    var selectType: PhotoToolBarType = PhotoToolBarType.filter

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(center: CGPoint, frame: CGRect) {
        self.init()
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
            self.imageView.frame = CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 70 - 64)
            self.imageView.center = CGPoint.init(x: SCREEN_WIDTH / 2, y: 64 + (SCREEN_HEIGHT - 70 - 64) / 2)
        }) { (complete) in
            self.startImageViewCenter = self.imageView.center
            self.startImageViewSize = self.imageView.frame.size
        }
    }
    
    func initView() {
        navigationBar()
        yz_navigationBar?.leftBtn.setImage(UIImage.init(named: "back_btn"), for: UIControl.State.normal)
        yz_navigationBar?.leftBtn.addTarget(self, action: #selector(backBtnDidClicked), for: UIControl.Event.touchUpInside)
        yz_navigationBar?.rightBtn.setImage(UIImage.init(named: "edit_save_btn"), for: UIControl.State.normal)
        yz_navigationBar?.rightBtn.isHidden = false
        yz_navigationBar?.rightBtn.addTarget(self, action: #selector(saveBtnDidClicked), for: UIControl.Event.touchUpInside)
        yz_navigationBar?.titleLabel.text = "编辑"
        yz_navigationBar?.layer.zPosition = 99
        view.addSubview(imageView)
        view.addSubview(toolBar)
        view.addSubview(toolItemBar)
        view.addSubview(operationBar)
        view.addSubview(sliderBar)
        view.addSubview(crossBar)
        
        imageView.frame = startFrame
        imageView.center = startCenter
        
        toolBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(70)
        }
        
        operationBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(34)
        }
        
        toolItemBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(operationBar.snp.top)
            make.height.equalTo(70 + 10)
        }
        
        sliderBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(operationBar.snp.top)
            make.height.equalTo(70 + 10)
        }
        
        crossBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(operationBar.snp.top)
            make.height.equalTo(70 + 10)
        }
        
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(imageViewOnPinch(pinch:)))
        view.addGestureRecognizer(pinch)
    }
    
    var asset: PHAsset? {
        willSet {
            AlbumManager.shared.getOriginalImage(asset: newValue!) { (image) in
                self.imageView.image = image
                self.originalImage = image
            }
        }
    }
    
    @objc func backBtnDidClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnDidClicked() {
        AlbumManager.shared.save(image: imageView.image!)
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
                    self.dismiss(animated: true, completion: nil)
                }
            }else {
                UIView.animate(withDuration: 0.2) {
                    self.view.backgroundColor = UIColor.init(white: 1, alpha: 1)
                    self.imageView.frame = CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 70 - 64)
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
                let feed = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
                feed.impactOccurred()
            }
        }
    }
    
    // MARK: EditPhotoToolBarDelegate
    func didSelectToolItem(type: PhotoToolBarType) {
        selectType = type
        switch selectType {
        case .filter:
            toolItemBar.barType = type
            getFilterArray()
            showMoreToolBar(view: toolItemBar)
            break
        case .blur:
            showMoreToolBar(view: sliderBar)
            break
        case .cross:
            showMoreToolBar(view: crossBar)
            break
        case .sharpen:
            showMoreToolBar(view: sliderBar)
            break
        }
    }
    
    // MARK: EditSelectToolBarDelegate
    func itemDidSelect(index: Int) {
        switch toolItemBar.barType {
        case .filter:
            imageView.image = FilterManager.shared.getEffectFilter(style: FilterStyleEffect.style(index: index), image: originalImage)
            break
        case .blur:
            break
        case .cross:
            break
        case .sharpen:
            break
        }
    }
    
    // MARK: EditOperationBarDelegate
    func imageShouldChange(isSave: Bool) {
        if isSave == true {
            originalImage = imageView.image!
        }else {
            imageView.image = originalImage
        }
        hiddenAllMoreToolBar()
    }
    
    // MARK: EditSliderToolBarDelegate
    func valueDidChanged(value: Float) {
        if self.selectType == PhotoToolBarType.blur {
            imageView.image = FilterManager.shared.blurFilter(image: originalImage, value: value)
        }else if self.selectType == PhotoToolBarType.sharpen {
            imageView.image = FilterManager.shared.sharpenFilter(image: originalImage, value: value)
        }
    }
    
    // MARK: EditCrossToolBarDelegate
    func crossValueDidChange(red: Array<CGFloat>, green: Array<CGFloat>, blue: Array<CGFloat>) {
        imageView.image = FilterManager.shared.crossFilter(image: originalImage, red: red, green: green, blue: blue)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard toolBar.isHidden == true  else {
            return
        }
        let point = touches.first?.location(in: view)
        guard (point?.y)! <= SCREEN_HEIGHT - 114 else {
            return
        }
        hiddenAllMoreToolBar()
    }
    
    private func hiddenAllMoreToolBar() {
        hiddenMoreToolBar(view: toolItemBar)
        hiddenMoreToolBar(view: crossBar)
        hiddenMoreToolBar(view: sliderBar)
    }
    
    private func showMoreToolBar(view: UIView) {
        view.isHidden = false
        view.alpha = 0
        operationBar.isHidden = false
        operationBar.alpha = 0
        yz_navigationBar?.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 1
            self.toolBar.alpha = 0
            self.operationBar.alpha = 1
            self.imageView.center = CGPoint.init(x: self.startImageViewCenter.x, y: self.startImageViewCenter.y - 44)
        }) { (complete) in
            self.toolBar.alpha = 1
            self.toolBar.isHidden = true
        }
    }
    
    private func hiddenMoreToolBar(view: UIView) {
        toolBar.isHidden = false
        toolBar.alpha = 0
        self.toolBar.setCellState(indexPath: self.toolBar.lastIndexPath, selected: false)
        UIView.animate(withDuration: 0.3, animations: {
            self.toolBar.alpha = 1
            view.alpha = 0
            self.operationBar.alpha = 0
            self.imageView.center = self.startImageViewCenter
        }) { (complete) in
            view.isHidden = true
            view.alpha = 1
            self.operationBar.alpha = 1
            self.operationBar.isHidden = true
            self.yz_navigationBar?.isHidden = false
        }
    }
    
    private func getFilterArray() {
        AlbumManager.shared.getImage(asset: asset!, size: CGSize.init(width: 50, height: 50)) { (image) in
            FilterManager.shared.allEffectFilter(image: image) { (array) in
                self.toolItemBar.dataArray = array
            }
        }
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.clipsToBounds = true
        view.contentMode = UIImageView.ContentMode.scaleAspectFit
        view.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(imageViewOnPan(pan:)))
        view.addGestureRecognizer(pan)
        return view
    }()
    
    lazy var toolBar: EditPhotoToolBar = {
        let view = EditPhotoToolBar()
        view.yz_delegate = self
        return view
    }()
    
    lazy var toolItemBar: EditSelectToolBar = {
        let view = EditSelectToolBar()
        view.yz_delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var operationBar: EditOperationBar = {
        let view = EditOperationBar()
        view.yz_delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var sliderBar: EditSliderToolBar = {
        let view = EditSliderToolBar()
        view.yz_delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var crossBar: EditCrossToolBar = {
        let view = EditCrossToolBar()
        view.isHidden = true
        view.yz_delegate = self
        return view
    }()
}
