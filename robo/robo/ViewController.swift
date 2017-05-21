//
//  ViewController.swift
//  robo
//
//  Created by Reza Shayestehpour on 5/17/17.
//  Copyright © 2017 Shayestehpour. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var motionManager : CMMotionManager = CMMotionManager()
    var asyncSocket : GCDAsyncSocket = GCDAsyncSocket()

    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slider.maximumValue = 100
        self.slider.minimumValue = -100
        self.slider.value = 0
        
        self.initMotionManager()
        
        let url = URL(string: "http://172.20.10.6:8080/?action=stream")
        let requestObject = URLRequest(url: url!)
        self.webView.loadRequest(requestObject)
        self.webView.scrollView.isScrollEnabled = false
        self.webView.scrollView.bounces = false
        
        self.initSocket()
    }
    
    func initSocket() {
        var socketDelegateQ : DispatchQueue
        socketDelegateQ = DispatchQueue(label: "com.shayestehpour.socketDelegateQ")
        
        self.asyncSocket = GCDAsyncSocket(delegate: self, delegateQueue: socketDelegateQ)
        
        do {
            try self.asyncSocket.connect(toHost: "172.20.10.6", onPort: 9001)
        } catch {
            print("error connecting to host")
        }
    }
    
    func initMotionManager() {
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 0.01
            self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { data, error in
                print(data?.gravity.x ?? "XXX", data?.gravity.y ?? "YYY", data?.gravity.z ?? "ZZZ")
                
                self.slider.setValue(self.gravityY(y: (data?.gravity.y)!), animated: true)
                
                let str = "*\(Int(self.gravityY(y: (data?.gravity.y)!)))*"
                self.asyncSocket.write(str.data(using: .ascii), withTimeout: -1, tag: 0)
            })
        }
    }
    
    func gravityY(y : Double) -> Float {
        if y > 0.5 {
            return -100.0
        } else if y < -0.5 {
            return 100.0
        }
        return Float(y * (-200.0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

