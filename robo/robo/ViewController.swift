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

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slider.maximumValue = 100
        self.slider.minimumValue = -100
        self.slider.value = 0
        
        self.initMotionManager()
        
        let url = URL(string: "https://www.google.com")
        let requestObject = URLRequest(url: url!)
        self.webView.loadRequest(requestObject)
        self.webView.scrollView.isScrollEnabled = false
        self.webView.scrollView.bounces = false
    }
    
    func initMotionManager() {
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 0.01
            self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { data, error in
                print(data?.gravity.x ?? "XXX", data?.gravity.y ?? "YYY", data?.gravity.z ?? "ZZZ")
                
                self.slider.setValue(Float((data?.gravity.y)! * (-100.0)), animated: true)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

