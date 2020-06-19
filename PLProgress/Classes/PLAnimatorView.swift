//
//  PLAnimatorView.swift
//  PLProgress
//
//  Created by 彭磊 on 2020/6/19.
//

import UIKit

public class PLAnimatorView: UIView {
    public let aView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
    public let progresView = UIProgressView(progressViewStyle: .default)
    public var animator: UIViewPropertyAnimator?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        progresView.frame = CGRect(x: 0, y: 100, width: 300, height: 1)
        progresView.progressTintColor = UIColor.red
        progresView.progress = 0
        self.addSubview(progresView)
        progresView.layoutIfNeeded()
        animator = UIViewPropertyAnimator(duration: 10, curve: .linear, animations: {
            self.progresView.setProgress(1, animated: false)
            self.progresView.layoutIfNeeded()
        })
        animator?.pausesOnCompletion = true
        animator?.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
