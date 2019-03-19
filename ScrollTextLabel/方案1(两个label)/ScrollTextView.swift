//
//  ScrollTextView.swift
//  ScrollTextLabel
//
//  Created by L on 2019/3/18.
//  Copyright © 2019 L. All rights reserved.
//

import UIKit

class ScrollTextView: UIView {
    
    var textFont = UIFont.systemFont(ofSize: 16)
    var textColor = UIColor.black
    
    /// 滚动速度 pixels/second
    var velocity: CGFloat = 80
    
    var text = "" {
        willSet {
            defaultLabel.text = newValue
            cycleLabel.text = newValue
        } didSet {
            scrollText()
        }
        
    }
    
    /// 滚动停止 到 下次开始滚动的间隔时间
    var scrollIntervals: CFTimeInterval = 5
    
    /// 2个Label 首尾的间隔
    private var labelSpace: CGFloat = 10
    
    private lazy var contentView: UIView = {
        
        let view = UIView(frame: bounds)
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var defaultLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = textColor
        label.textAlignment = .center
        label.font = textFont
        label.text = text
        
        return label
    }()
    
    private lazy var cycleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = textColor
        label.textAlignment = .center
        label.font = textFont
        label.text = text
        label.isHidden = true
        
        return label
    }()
    
    private lazy var scrollAnimation: CABasicAnimation = {
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.beginTime = scrollIntervals
        animation.repeatDuration = CFTimeInterval(MAXFLOAT)
        animation.fromValue = 0
        
        return animation
    }()
    
    private lazy var scrollAnimationGroup: CAAnimationGroup = {
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [CABasicAnimation(), scrollAnimation]
        animationGroup.repeatDuration = CFTimeInterval(MAXFLOAT)
        animationGroup.fillMode = .backwards
        
        return animationGroup
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupContent()
    }
    
    func addApplicationWakeUpScrollObserver() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollText), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollText), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

private extension ScrollTextView {
    
    func setupContent() {
        
        if text.count == 0 { return }
        
        contentView.removeFromSuperview()
    
        addSubview(contentView)
        
        contentView.addSubview(defaultLabel)
        contentView.addSubview(cycleLabel)
        
        scrollText()
    }
    
    @objc func scrollText() {
        
        let calculateSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: frame.size.height)
        let textSize = text.boundingRect(with: calculateSize, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context:nil)
        
        var calculateLableWidth = frame.size.width
        
        contentView.layer.removeAllAnimations()
        
        if textSize.width + 10 > calculateLableWidth { // tableView 刷新的时候, DispatchQueue.main.asyncAfter 个0.几秒
            
            calculateLableWidth = textSize.width + labelSpace
            
            cycleLabel.isHidden = false
            
            // CFTimeInterval((calculateLableWidth - frame.size.width)/velocity)
            let duration = CFTimeInterval(calculateLableWidth/velocity)
            
            scrollAnimation.duration = duration
            scrollAnimation.toValue = -calculateLableWidth
            scrollAnimationGroup.duration = CFTimeInterval(scrollIntervals + duration)
            
            contentView.layer.add(scrollAnimationGroup, forKey: nil)
        }
        
        defaultLabel.frame = CGRect(x: 0, y: 0, width: calculateLableWidth, height: frame.size.height)
        
        cycleLabel.frame = defaultLabel.frame.offsetBy(dx: calculateLableWidth, dy: 0)
        
    }
    
}
