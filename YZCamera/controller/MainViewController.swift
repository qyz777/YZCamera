//
//  MainViewController.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/21.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCapturePhotoCaptureDelegate, MainBottomViewDelegate {
    
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var bottomView : MainBottomView = {
        let view = MainBottomView.init()
        view.yz_delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        cameraConfig()
    }

    func initView() -> Void {
        view.backgroundColor = UIColor.white
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(180)
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
            previewLayer?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            view.layer.insertSublayer(previewLayer!, at: 0)
            session?.startRunning()
        }
    }
    
    // MARK: MainBottomViewDelegate
    func photoBtnDidClick() {
        let setting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey : AVVideoCodecJPEG])
        photoOutput?.capturePhoto(with: setting, delegate: self)
    }
    
    // MARK: AVCapturePhotoCaptureDelegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        let imgData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        let image = UIImage.init(data: imgData!)
    }
}
