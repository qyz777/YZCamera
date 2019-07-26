//
//  MainViewController.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/21.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController,
    AVCapturePhotoCaptureDelegate,
    AVCaptureVideoDataOutputSampleBufferDelegate,
    MainBottomViewDelegate,
    MainTopViewDelegate
{
    
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var videoOutput: AVCaptureVideoDataOutput?
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        cameraConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func initView() -> Void {
        view.addSubview(backView)
        view.addSubview(bottomView)
        view.addSubview(topView)
        view.addSubview(filterView)
        
        backView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(view)
            make.height.equalTo(SCREEN_HEIGHT - 180)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(backView.snp.bottom)
        }
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        filterView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(backView.snp.bottom)
        }
    }
    
    func cameraConfig() -> Void {
        device = AVCaptureDevice.default(for: AVMediaType.video)
        input = try? AVCaptureDeviceInput.init(device: device!)
        if (input != nil) {
            let outputSettings = AVCapturePhotoSettings.init(format: [AVVideoCodecKey : AVVideoCodecJPEG])
            photoOutput = AVCapturePhotoOutput.init()
            photoOutput?.photoSettingsForSceneMonitoring = outputSettings
            
            videoOutput = AVCaptureVideoDataOutput.init()
            let queue = DispatchQueue.init(label: "YZCamera.video")
            videoOutput?.setSampleBufferDelegate(self, queue: queue)
            
            session = AVCaptureSession.init()
            session?.addInput(input!)
            session?.addOutput(photoOutput!)
            previewLayer = AVCaptureVideoPreviewLayer.init(session: session!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 180)
            backView.layer.insertSublayer(previewLayer!, at: 0)
            session?.startRunning()
        }
    }
    
    // MARK: MainBottomViewDelegate
    func photoBtnDidClick() {
        let setting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey : AVVideoCodecJPEG])
        photoOutput?.capturePhoto(with: setting, delegate: self)
    }
    
    func shouldPresentPhotoAlbum() {
        let nav = UINavigationController.init(rootViewController: AlbumViewController())
        present(nav, animated: true, completion: nil)
    }
    
    func filterViewShouldShow() {
        session?.addOutput(videoOutput!)
        filterView.isHidden = false
        filterView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.filterView.alpha = 1
            self.bottomView.alpha = 0
        }) { (complete) in
            self.bottomView.alpha = 1
            self.bottomView.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard filterView.isHidden == false else {
            return
        }
        session?.removeOutput(videoOutput!)
        let position = touches.first?.location(in: view)
        if (position?.y)! <= SCREEN_HEIGHT - 180 {
            bottomView.isHidden = false
            bottomView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomView.alpha = 1
                self.filterView.alpha = 0
            }) { (complete) in
                self.filterView.alpha = 1
                self.filterView.isHidden = true
            }
        }
    }
    
    // MARK: MainTopViewDelegate
    func cameraShouldSwitch() {
        let inUseDevide = inUseCamera()
        if inUseDevide != nil {
            let deviceInput = try? AVCaptureDeviceInput.init(device: inUseDevide!)
            session?.beginConfiguration()
            session?.removeInput(input!)
            if (session?.canAddInput(deviceInput!))! {
                session?.addInput(deviceInput!)
                device = inUseDevide
                input = deviceInput
            }else {
                session?.addInput(input!)
            }
            session?.commitConfiguration()
        }else {
            print("摄像头切换错误")
        }
    }
    
    // MARK: AVCapturePhotoCaptureDelegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        let imgData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        let vc = SaveViewController()
        vc.imageData = imgData
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let image = handleSampleBuffer(buffer: sampleBuffer) else { return }
        var dataArray: Array<FilterModel> = []
        for style in GPUFilterStyle.allCases {
            let filter = style.instance
            let filterImage = filter.image(byFilteringImage: image)
            let model = FilterModel.init()
            model.filterImage = filterImage
            model.title = style.title
            dataArray.append(model)
        }
        DispatchQueue.main.async {
            self.filterView.dataArray = dataArray
        }
    }
    
    // MARK: private
    private func cameraWith(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discovery = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position)
        let devices = discovery.devices
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    private func inUseCamera() -> AVCaptureDevice? {
        let device: AVCaptureDevice?
        if self.device?.position == AVCaptureDevice.Position.back {
            device = cameraWith(position: AVCaptureDevice.Position.front) ?? nil
        }else {
            device = cameraWith(position: AVCaptureDevice.Position.back) ?? nil
        }
        return device
    }
    
    private func handleSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        guard CMSampleBufferIsValid(buffer) == true else { return nil }
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)
        let ciImage: CIImage = CIImage.init(cvPixelBuffer: imageBuffer!)
        let image = UIImage.init(ciImage: ciImage).yz.scaleImage(scale: 0.1)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width)
        let cgImage = image.yz.convertToCGImage()
        guard let cgImageCorpped = cgImage.cropping(to: rect) else { return nil }
        let newImage = UIImage.init(cgImage: cgImageCorpped, scale: 1, orientation: UIImage.Orientation.right)
        return newImage
    }
    
    // MARK: lazy
    lazy var backView: UIView = {
        let view = UIView.init()
        return view
    }()
    
    lazy var bottomView: MainBottomView = {
        let view = MainBottomView.init()
        view.yz_delegate = self
        return view
    }()
    
    lazy var topView: MainTopView = {
        let view = MainTopView.init()
        view.yz_delegate = self
        return view
    }()
    
    lazy var filterView: MainFilterView = {
        let view = MainFilterView()
        view.isHidden = true
        return view
    }()
}
