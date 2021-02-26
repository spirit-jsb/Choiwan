//
//  VMBackgroundView.swift
//  Choiwan
//
//  Created by Max on 2021/2/26.
//

#if canImport(UIKit)

import UIKit

public class VMBackgroundView: UIView {
  
  public var backgroundStyle: VMBackgroundStyle = .blur {
    didSet {
      if self.backgroundStyle != oldValue {
        self.resetBackgroundStyle()
      }
    }
  }
  
  public var blurEffectStyle: UIBlurEffect.Style = .light {
    didSet {
      if self.blurEffectStyle != oldValue {
        self.resetBackgroundStyle()
      }
    }
  }
  
  public var solidColor: UIColor = UIColor(white: 0.8, alpha: 0.6) {
    didSet {
      if self.solidColor != oldValue {
        self.resetBackgroundColor()
      }
    }
  }
  
  private var effectView: UIVisualEffectView?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.initialize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return .zero
  }
  
  private func initialize() {
    self.clipsToBounds = true
    
    self.resetBackgroundStyle()
  }
  
  private func resetBackgroundStyle() {
    self.effectView?.removeFromSuperview()
    self.effectView = nil
    
    if self.backgroundStyle == .blur {
      let blurEffect = UIBlurEffect(style: self.blurEffectStyle)
      let effectView = UIVisualEffectView(effect: blurEffect)
      
      effectView.frame = self.bounds
      effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
      self.insertSubview(effectView, at: 0)
      
      self.backgroundColor = self.solidColor
      self.layer.allowsGroupOpacity = false
      
      self.effectView = effectView
    }
    else {
      self.backgroundColor = self.solidColor
    }
  }
  
  private func resetBackgroundColor() {
    self.backgroundColor = self.solidColor
  }
}

#endif
