//
//  RKBarcodeScanner.swift
//
//  Created by Callum Trounce on 03/11/2017.
//  Copyright © 2017 RokketPowered. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol RKBarcodeScannerDelegate: NSObjectProtocol {
    func failedToSetup(withError error: Error)
}

public class RKBarcodeScanner: UIView {
    
    public typealias barcodeClosure = (String) -> Void
    fileprivate var barcodeResultBlock: barcodeClosure?
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var captureSession: AVCaptureSession?
    
    weak var delegate: RKBarcodeScannerDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        configurePreviewLayer()
        configureCaptureSession()
        configureMetadataOutput()
    }
    
    private func configureView() {
        backgroundColor = .black
    }
    
    private func configurePreviewLayer() {
        
        captureSession = AVCaptureSession()
        
        if let captureSession = captureSession {
            previewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)
        }
    }
    
    private func configureCaptureSession() {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch (let error) {
            delegate?.failedToSetup(withError: error)
            return
        }
        
        if let captureSession = captureSession, captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
    }
    
    private func configureMetadataOutput() {
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if let captureSession = captureSession, captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
    }
    
    private func failed() {
        print("SETUP OF CAPTURE FAILED")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = layer.bounds
    }
    
}

public extension RKBarcodeScanner {
    
    
    /// Begin capturing and waiting for a barcode
    ///
    /// - Parameter barcode: a closure containing any detected barcodes
    func beginCapture(withResult barcode: @escaping barcodeClosure) {
        barcodeResultBlock = barcode
        captureSession?.startRunning()
    }
    
    /// Stops capturing and removes the closure.
    func stopCapture() {
        barcodeResultBlock = nil
        captureSession?.stopRunning()
    }
    
    
    /// Stops capturing, and removes everything.
    func teardown() {
        stopCapture()
        captureSession = nil
        previewLayer.removeFromSuperlayer()
    }
}

extension RKBarcodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            if let block = barcodeResultBlock {
                block(stringValue)
            }
        }
        
    }
}
