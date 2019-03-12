//
//  Home.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/11.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import UIKit
import AVFoundation

class Home: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onButtonQR(_ sender: Any) {
        
        showQRCodeReader()
    }
    
    @IBAction func onButtonWeather(_ sender: Any) {
     
        moveToNextPage(nextStoryboardName: "weatherPage")
    }
    
    @IBAction func onButtonDB(_ sender: Any) {
        
        moveToNextPage(nextStoryboardName: "DBAccessPage")
    }
    
    private func showQRCodeReader() {
        
        // カメラやマイクのデバイスそのものを管理するオブジェクトを生成（ここではワイドアングルカメラ・ビデオ・背面カメラを指定）
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
        
        // ワイドアングルカメラ・ビデオ・背面カメラに該当するデバイスを取得
        let devices = discoverySession.devices
        
        //　該当するデバイスのうち最初に取得したものを利用する
        if let backCamera = devices.first {
            do {
                // QRコードの読み取りに背面カメラの映像を利用するための設定
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                
                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)
                    
                    // 背面カメラの映像からQRコードを検出するための設定
                    let metadataOutput = AVCaptureMetadataOutput()
                    
                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)
                        
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [.qr]
                        
                        // 背面カメラの映像を画面に表示するためのレイヤーを生成
                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                        previewLayer.frame = self.view.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        self.view.layer.addSublayer(previewLayer)
                        
                        // 読み取り可能エリアの設定を行う
                        // 画面の横、縦に対して、左が25%、上が35%のところに、横幅50%、縦幅30%を読み取りエリアに設定
                        let x: CGFloat = 0.25
                        let y: CGFloat = 0.35
                        let width: CGFloat = 0.5
                        let height: CGFloat = 0.3
                        metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
                        
                        // 読み取り可能エリアに赤い枠を追加する
                        let detectionArea = UIView()
                        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
                        detectionArea.layer.borderColor = UIColor.red.cgColor
                        detectionArea.layer.borderWidth = 3
                        view.addSubview(detectionArea)
                        
                        // 閉じるボタン
                        let closeBtn:UIButton = UIButton()
                        closeBtn.frame = CGRect(x: 50, y: 50, width: 100, height: 40)
                        closeBtn.setTitle("閉じる", for: UIControl.State.normal)
                        closeBtn.backgroundColor = UIColor.lightGray
                        closeBtn.addTarget(self, action: #selector(closeTaped(sender:)), for: .touchUpInside)
                        self.view.addSubview(closeBtn)
                        
                        // 読み取り開始
                        self.session.startRunning()
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
    
    // QRコードリーダー画面で閉じるがタップされたら画面を閉じる
    @objc private func closeTaped(sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            
            // QRコードのデータかどうかの確認
            guard metadata.type == .qr else { continue }
            
            // QRコードの内容に中身があるか確認
            guard let str = metadata.stringValue else { continue }
            
            //画面間共通で参照できる変数に値を格納した上で画面遷移
            CommonValue.QRStringValue = str
            moveToNextPage(nextStoryboardName: "QRResultPage")
            break
        }
    }
    
    //storyboard名を受け取り、その画面に遷移する
    private func moveToNextPage(nextStoryboardName name: String) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let nextViewController = storyboard.instantiateInitialViewController()!
        present(nextViewController, animated: true, completion: nil)
    }
}
