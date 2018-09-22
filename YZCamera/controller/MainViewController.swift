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
MainBottomViewDelegate,
MainTopViewDelegate {
    
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
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
        view.backgroundColor = UIColor.white
        view.addSubview(backView)
        view.addSubview(bottomView)
        view.addSubview(topView)
        
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
    }
    
    func cameraConfig() -> Void {
        device = AVCaptureDevice.default(for: AVMediaType.video)
        input = try? AVCaptureDeviceInput.init(device: device!)
        if (input != nil) {
            let outputSettings = AVCapturePhotoSettings.init(format: [AVVideoCodecKey : AVVideoCodecJPEG])
            photoOutput = AVCapturePhotoOutput.init()
            photoOutput?.photoSettingsForSceneMonitoring = outputSettings
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
        present(AlbumViewController(), animated: true, completion: nil)
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
}
