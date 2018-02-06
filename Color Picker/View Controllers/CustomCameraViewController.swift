//
//  CustomCameraViewController.swift
//  Color Picker
//
//  Created by Chris Gray on 1/26/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var colorBarButton: UIBarButtonItem!
    @IBOutlet weak var hexBarButton: UIBarButtonItem!
    @IBOutlet weak var rgbBarButton: UIBarButtonItem!
    
    @IBOutlet weak var pixelTargetView: PixelTargetView!
    @IBOutlet weak var cameraView: UIView!
    
    private let captureSession = AVCaptureSession()
    private var cameraDevice: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private var centerColor = UIColor.white
    
    private var sensitivity = 10
    
    //MARK: - Override methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: pixelTargetView)
        
        let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        for camera in videoDeviceDiscoverySession.devices as [AVCaptureDevice] {
            if camera.position == .back {
                cameraDevice = camera
            }
        }
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: cameraDevice!)
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            }
        } catch {
//            print(error)
        }
        initializePreviewLayer()
        captureSession.startRunning()
        initializeVideoOutput()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeSensitivity(_:)), name: NSNotification.Name("changeSensitivity"), object: nil)
    }
    
    @objc func changeSensitivity(_ notification: NSNotification) {
        if let sensitivitySetting = notification.userInfo?["sensitivity"] as? Int {
            sensitivity = sensitivitySetting
        }
    }
    
    //MARK: - Video Capture
    
    private func initializePreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(previewLayer)
    }
    
    private func initializeVideoOutput() {
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        
        let videoQueue = DispatchQueue(label: "VideoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            //after view disappears and re-appears, this else statement executes
            //maybe because the capture session already has a video output?
            print("Cannot add video output")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            processImageBuffer(imageBuffer)
        }
    }
    
    private func processImageBuffer(_ imageBuffer: CVPixelBuffer) {
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)!
        let byteBuffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        
        DispatchQueue.main.async { [weak weakSelf = self] in //need this?
            if let newColor = weakSelf?.getColorFromCenter(byteBuffer: byteBuffer, width: width, height: height) {
                weakSelf?.setBarButtonColors(color: newColor)
            }
        }
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
    }
    
    //MARK: - Colors
    
    private func setBarButtonColors(color: UIColor) {
        let (red, green, blue, _) = color.rgbValues
        let rgbIntValues = (Int(red*255), Int(green*255), Int(blue*255))
        let (intRed, intGreen, intBlue) = (rgbIntValues.0, rgbIntValues.1, rgbIntValues.2)
        
        let (currentRed, currentGreen, currentBlue, _) = centerColor.rgbValues
        let (currentIntRed, currentIntGreen, currentIntBlue) = (Int(currentRed*255), Int(currentGreen*255), Int(currentBlue*255))
        
        //User can decide how sensitive the color changes are
        if abs(currentIntRed - intRed) > sensitivity || abs(currentIntGreen - intGreen) > sensitivity || abs(currentIntBlue - intBlue) > sensitivity {
            centerColor = color
            colorBarButton.tintColor = color
            hexBarButton.title = "#\(color.hexValue)"
            rgbBarButton.title = String(describing: rgbIntValues)
        }
    }
    
    private func getColorFromCenter(byteBuffer: UnsafeMutablePointer<UInt8>, width: Int, height: Int) -> UIColor {
        
        let pixelByteLocation = ((Int(width) * Int(height/2)) + Int(width/2)) * 4
        
        //kCVPixelFormatType_32BGRA
        //TODO: sometimes this crashes when switching back and forth quickly
        let b = CGFloat(byteBuffer[pixelByteLocation])/255
        let g = CGFloat(byteBuffer[pixelByteLocation + 1])/255
        let r = CGFloat(byteBuffer[pixelByteLocation + 2])/255
        let a = CGFloat(byteBuffer[pixelByteLocation + 3])/255
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
