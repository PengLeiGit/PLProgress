//
//  ViewController.swift
//  PLProgress
//
//  Created by 1248667206@qq.com on 06/19/2020.
//  Copyright (c) 2020 1248667206@qq.com. All rights reserved.
//

import UIKit
import PLProgress

class ViewController: UIViewController {
    
    lazy var progressViewLayer: PLProgressLayer = {
        let view = PLProgressLayer()
        view.animatingStatus = .animationStatusIdle
        view.fillLayer.backgroundColor = UIColor.cyan.cgColor //已有进度颜色
        view.backgroundColor = UIColor.lightGray.cgColor //剩余进度颜色（即进度槽颜色）
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.addSublayer(progressViewLayer)
        progressViewLayer.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width - 40, height: 2)
//        UIApplication.willResignActiveNotification
        NotificationCenter.default.addObserver(self, selector: #selector(enterBG), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
//        UIApplication.willEnterForegroundNotification
        NotificationCenter.default.addObserver(self, selector: #selector(enterFG), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressViewLayer.startAnimation()
    }
    
    @objc func enterBG() {
        self.progressViewLayer.pauseAnimation()
    }
    
    @objc func enterFG() {
        if self.progressViewLayer.animatingStatus == .animationStatusPause {
            self.progressViewLayer.resumeAnimation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

