//
//  QRScannerVC.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 03/08/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    var video = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Accessing camera
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
            
        } catch {
            displayAlertMessage(alertMessage: "Woops")
        }
        
        let output = AVCaptureMetadataOutput()
        
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }

    
    // Reading data as QR code
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                
                if object.type == AVMetadataObjectTypeQRCode {
                    
                    // Options to scan another/again or go to browser
                    
                    let alert = UIAlertController(title: "Alert", message: "Open \(object.stringValue!)?", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelButton = UIAlertAction(title: "Scan again", style: UIAlertActionStyle.default, handler: nil)
                    let logInButton = UIAlertAction(title: "Open", style: UIAlertActionStyle.default, handler: { (nil) in
                        let url = URL(string: object.stringValue)
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    })
                    
                    alert.addAction(cancelButton)
                    alert.addAction(logInButton)
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    

}
