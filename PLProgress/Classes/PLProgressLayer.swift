//
//  PLProgressLayer.swift
//  PLProgress
//
//  Created by 彭磊 on 2020/6/19.
//

import UIKit

public enum LayerStatus {
    case animationStatusIdle // 空闲
    case animationStatusAnimating // 动画中
    case animationStatusPause // 暂停
    case animationStatusComplete // 完成
}

public protocol DuProgressLayerDelegate: NSObjectProtocol {
    func animationStop(layer: CALayer)
}

public class PLProgressLayer: CALayer {
    public var animatingStatus: LayerStatus?
    weak var layerDelegate: DuProgressLayerDelegate?
    public var fillLayer = CALayer()
    var timer: CADisplayLink?
    var pauseProgress: CGFloat = 0
    
    // 开始动画
    @objc public dynamic func startAnimation() {
        resetAnimation()
        let fromPath = CGRect(x: 0, y: 0, width: 0, height: self.bounds.size.height)
        self.fillLayer.bounds = self.bounds
        let toPath = self.bounds
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = fromPath
        animation.toValue = toPath
        animation.delegate = self
        animation.duration = 10
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        self.fillLayer.add(animation, forKey: "progressAnimation")
        self.fillLayer.layoutIfNeeded()
        animatingStatus = .animationStatusAnimating
        
    }
    
    // 暂停动画
    public func pauseAnimation() {
        guard let presentLayer = self.fillLayer.presentation() else {
            return
        }
        self.pauseProgress = presentLayer.bounds.width / bounds.width
        let width = presentLayer.bounds.width
        self.fillLayer.bounds = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        self.fillLayer.removeAllAnimations()
        animatingStatus = .animationStatusPause
        self.backgroundColor = UIColor.lightGray.cgColor //剩余进度颜色（即进度槽颜色）
        self.fillLayer.backgroundColor = UIColor(white: 1, alpha: 0.3).cgColor
    }
    
    // 恢复动画
    public func resumeAnimation() {
        let fromPath = CGRect(x: 0, y: 0, width: self.bounds.size.width * pauseProgress, height: self.bounds.size.height)
        self.fillLayer.bounds = self.bounds
        let toPath = self.bounds
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = fromPath
        animation.toValue = toPath
        animation.delegate = self
        animation.duration = Double((1 - pauseProgress) * 10)
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        self.fillLayer.add(animation, forKey: "progressAnimation")
        self.fillLayer.layoutIfNeeded()
        animatingStatus = .animationStatusAnimating
        self.backgroundColor = UIColor.lightGray.cgColor //剩余进度颜色（即进度槽颜色）
        self.fillLayer.backgroundColor = UIColor(white: 1, alpha: 1).cgColor
    }
    
    // 重置
    @objc dynamic func resetAnimation() {
        self.removeAllAnimations()
        fillLayer.frame = CGRect(x: 0, y: 0, width: 0, height: self.bounds.size.height)
        fillLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        if fillLayer.superlayer == nil {
            addSublayer(fillLayer)
        }
        fillLayer.layoutIfNeeded()
    }

}


extension PLProgressLayer: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        print("动画开始了")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            print("完成了动画")
            animatingStatus = .animationStatusComplete
            layerDelegate?.animationStop(layer: self)
        }
    }
}
