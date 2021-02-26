//
//  VMProgressView.swift
//  Choiwan
//
//  Created by Max on 2021/2/26.
//

#if canImport(UIKit)

import UIKit

public class VMProgressView: UIView {
  
  var progress: Float = 0.0 {
    willSet {
      if newValue < 0.0 || newValue > 1.0 {
        return
      }
      self.setNeedsDisplay()
    }
  }
  
  var progressTintColor: UIColor? {
    didSet {
      if self.progressTintColor != oldValue {
        self.setNeedsDisplay()
      }
    }
  }
  
  var trackTintColor: UIColor? {
    didSet {
      if self.trackTintColor != oldValue {
        self.setNeedsDisplay()
      }
    }
  }
  
  private var mode: VMHUDMode!
  
  public init(mode: VMHUDMode) {
    guard mode == .barProgress || mode == .ringProgress || mode == .sectorProgress else { fatalError("VMProgressView can't match this mode") }
    
    self.mode = mode
    super.init(frame: CGRect(origin: .zero, size: mode.contentSize))
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.initialize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return self.mode.contentSize
  }
  
  public override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    
  }
  
  private func initialize() {
    self.backgroundColor = UIColor.clear
    self.isOpaque = false
  }
  
  private func drawBackground() {
    
  }
  
  private func drawProgress() {
    
  }
}

extension VMHUDMode {
  
  var contentSize: CGSize {
    switch self {
    case .barProgress: return CGSize(width: 120.0, height: 10.0)
    case .ringProgress: return CGSize(width: 40.0, height: 40.0)
    case .sectorProgress: return CGSize(width: 40.0, height: 40.0)
    default: fatalError("The value can't match this property")
    }
  }
}

#endif

/*
 public class JSSectorProgressView: UIView {
 
     public override func draw(_ rect: CGRect) {
         let context = UIGraphicsGetCurrentContext()
         
         let lineWidth: CGFloat = 1.0
         let circleRect = self.bounds.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
         
         // Draw background
         context?.setLineWidth(1.0)
         context?.setStrokeColor(self.progressTintColor.cgColor)
         context?.setFillColor(self.trackTintColor.cgColor)
         
         context?.strokeEllipse(in: circleRect)
         
         // Draw progress
         let progressPath = UIBezierPath()
         
         let center = CGPoint(x: rect.midX, y: rect.midY)
         let radius = (rect.height / 2.0) - 1.5
         let startAngle: CGFloat = -(.pi / 2.0)
         let endAngle = (CGFloat(self.progress) * 2.0 * .pi) + startAngle
         
         progressPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
         progressPath.addLine(to: center)
         
         context?.setBlendMode(.copy)
         
         self.progressTintColor.set()
         
         progressPath.fill()
     }
 }

 */

/*
 public class JSRingProgressView: UIView {

     public override func draw(_ rect: CGRect) {
         let context = UIGraphicsGetCurrentContext()

         let lineWidth: CGFloat = 2.0
         let circleRect = self.bounds.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
         
         // Draw background
         context?.setLineWidth(lineWidth)
         context?.setStrokeColor(self.progressTintColor.cgColor)
         context?.setFillColor(self.trackTintColor.cgColor)
         
         context?.strokeEllipse(in: circleRect)

         // Draw progress
         let progressPath = UIBezierPath()

         progressPath.lineWidth = lineWidth * 2.0
         progressPath.lineCapStyle = .butt
         
         let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
         let radius = (self.bounds.width / 2.0) - lineWidth
         let startAngle: CGFloat = -(.pi / 2.0)
         let endAngle = (CGFloat(self.progress) * 2.0 * .pi) + startAngle
         
         progressPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
         
         context?.setBlendMode(.copy)
         
         self.progressTintColor.set()
         
         progressPath.stroke()
     }
 }

 */

/*
 public class JSBarProgressView: UIView {

     public override func draw(_ rect: CGRect) {
         let content = UIGraphicsGetCurrentContext()
         
         let width = rect.width
         let height = rect.height
         let half_width = width / 2.0
         let half_height = height / 2.0
         
         let lineWidth: CGFloat = 2.0
         let double_lineWidth: CGFloat = 4.0
         
         // Draw background and border
         let backgroundRadius = half_height - lineWidth
         
         content?.setLineWidth(lineWidth)
         content?.setStrokeColor(self.progressTintColor.cgColor)
         content?.setFillColor(self.trackTintColor.cgColor)
         
         content?.move(to: CGPoint(x: lineWidth, y: half_height))
         content?.addArc(tangent1End: CGPoint(x: lineWidth, y: lineWidth), tangent2End: CGPoint(x: backgroundRadius + lineWidth, y: lineWidth), radius: backgroundRadius)
         content?.addArc(tangent1End: CGPoint(x: width - lineWidth, y: lineWidth), tangent2End: CGPoint(x: width - lineWidth, y: half_height), radius: backgroundRadius)
         content?.addArc(tangent1End: CGPoint(x: width - lineWidth, y: height - lineWidth), tangent2End: CGPoint(x: width - backgroundRadius - lineWidth, y: height - lineWidth), radius: backgroundRadius)
         content?.addArc(tangent1End: CGPoint(x: lineWidth, y: height - lineWidth), tangent2End: CGPoint(x: lineWidth, y: half_height), radius: backgroundRadius)
         
         content?.drawPath(using: .fillStroke)
         
         // Draw progress
         let progressWidth = width * CGFloat(self.progress)
         let progressRadius = half_height - double_lineWidth
         
         content?.setFillColor(self.progressTintColor.cgColor)
         
         if progressWidth >= progressRadius + double_lineWidth && progressWidth <= width - progressRadius - double_lineWidth {
             content?.move(to: CGPoint(x: double_lineWidth, y: half_height))
             content?.addArc(tangent1End: CGPoint(x: double_lineWidth, y: double_lineWidth), tangent2End: CGPoint(x: progressRadius + double_lineWidth, y: double_lineWidth), radius: progressRadius)
             content?.addLine(to: CGPoint(x: progressWidth, y: double_lineWidth))
             content?.addLine(to: CGPoint(x: progressWidth, y: height - double_lineWidth))
             content?.addLine(to: CGPoint(x: progressRadius + double_lineWidth, y: height - double_lineWidth))
             content?.addArc(tangent1End: CGPoint(x: double_lineWidth, y: height - double_lineWidth), tangent2End: CGPoint(x: double_lineWidth, y: half_height), radius: progressRadius)
             
             content?.fillPath()
         }
         else if progressWidth < progressRadius + double_lineWidth && progressWidth > 0.0 {
             content?.move(to: CGPoint(x: double_lineWidth, y: half_height))
             content?.addArc(tangent1End: CGPoint(x: double_lineWidth, y: double_lineWidth), tangent2End: CGPoint(x: progressRadius + double_lineWidth, y: double_lineWidth), radius: progressRadius)
             content?.addLine(to: CGPoint(x: progressRadius + double_lineWidth, y: height - double_lineWidth))
             content?.addArc(tangent1End: CGPoint(x: double_lineWidth, y: height - double_lineWidth), tangent2End: CGPoint(x: double_lineWidth, y: half_height), radius: progressRadius)
         
             content?.fillPath()
         }
         else if progressWidth > width - progressRadius - double_lineWidth {
             let tempX = progressWidth - (width - progressRadius - double_lineWidth)
             var angle = acos(tempX / progressRadius)
             if angle.isNaN {
                 angle = 0.0
             }
             
             content?.move(to: CGPoint(x: double_lineWidth, y: half_height))
             content?.addArc(tangent1End: CGPoint(x: double_lineWidth, y: double_lineWidth), tangent2End: CGPoint(x: progressRadius + double_lineWidth, y: double_lineWidth), radius: progressRadius)
             content?.addLine(to: CGPoint(x: width - progressRadius - double_lineWidth, y: double_lineWidth))
             
             content?.addArc(center: CGPoint(x: width - progressRadius - double_lineWidth, y: half_height), radius: progressRadius, startAngle: .pi, endAngle: -(angle), clockwise: false)
             content?.addLine(to: CGPoint(x: progressWidth, y: half_height))
             
             content?.move(to: CGPoint(x: double_lineWidth, y: half_height))
             content?.addArc(tangent1End: CGPoint(x: double_lineWidth, y: height - double_lineWidth), tangent2End: CGPoint(x: progressRadius + double_lineWidth, y: height - double_lineWidth), radius: progressRadius)
             content?.addLine(to: CGPoint(x: width - progressRadius - double_lineWidth, y: height - double_lineWidth))
             
             content?.addArc(center: CGPoint(x: width - progressRadius - double_lineWidth, y: half_height), radius: progressRadius, startAngle: -(.pi), endAngle: angle, clockwise: true)
             content?.addLine(to: CGPoint(x: progressWidth, y: half_height))
             
             content?.fillPath()
         }
     }
 }

 */
