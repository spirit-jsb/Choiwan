//
//  VMProgressView.swift
//  Choiwan
//
//  Created by Max on 2021/2/26.
//

#if canImport(UIKit)

import UIKit

public class VMProgressView: UIView {
  
  public var progress: Float = 0.0 {
    willSet {
      if newValue < 0.0 || newValue > 1.0 {
        return
      }
      self.setNeedsDisplay()
    }
  }
  
  public var progressTintColor: UIColor? {
    didSet {
      if self.progressTintColor != oldValue {
        self.setNeedsDisplay()
      }
    }
  }
  
  public var trackTintColor: UIColor? {
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
    
    self.drawBackground(context: context)
    self.drawProgress(context: context, rect: rect)
  }
  
  private func initialize() {
    self.backgroundColor = UIColor.clear
    self.isOpaque = false
  }
  
  private func drawBackground(context: CGContext?) {
    guard let progressTintColor = self.progressTintColor, let trackTintColor = self.trackTintColor else { fatalError("Place set `progressTintColor` and `trackTintColor` property") }
    
    switch self.mode {
    case .barProgress:
      break
    case .ringProgress, .sectorProgress:
      context?.setLineWidth(self.mode.lineWidth)
      context?.setStrokeColor(progressTintColor.cgColor)
      context?.setFillColor(trackTintColor.cgColor)
      context?.strokeEllipse(in: self.mode.circleRect(bounds: self.bounds))
    default:
      break
    }
  }
  
  private func drawProgress(context: CGContext?, rect: CGRect) {
    guard let progressTintColor = self.progressTintColor else { fatalError("Place set `progressTintColor` and `trackTintColor` property") }
    
    switch self.mode {
    case .barProgress:
      break
    case .ringProgress, .sectorProgress:
      context?.setBlendMode(.copy)
      self.setArcPath(mode: self.mode, rect: rect, progressTintColor: progressTintColor)
    default:
      break
    }
  }
  
  private func setArcPath(mode: VMHUDMode, rect: CGRect, progressTintColor: UIColor) {
    let progressPath = UIBezierPath()
    
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = (rect.height / 2.0) - self.mode.lineWidth * 2.0
    let startAngle: CGFloat = -(.pi / 2.0)
    let endAngle: CGFloat = (CGFloat(self.progress) * 2.0 * .pi) + startAngle
    
    progressPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    progressTintColor.set()
    
    switch mode {
    case .ringProgress:
      progressPath.lineWidth = self.mode.lineWidth * 2.0
      progressPath.lineCapStyle = .butt
      progressPath.stroke()
    case .sectorProgress:
      progressPath.addLine(to: center)
      progressPath.fill()
    default:
      fatalError("Place use `ringProgress` or `sectorProgress` mode")
    }
  }
}

extension VMHUDMode {
  
  var contentSize: CGSize {
    switch self {
    case .barProgress: return CGSize(width: 120.0, height: 10.0)
    case .ringProgress, .sectorProgress: return CGSize(width: 40.0, height: 40.0)
    default: fatalError("The value can't match this property")
    }
  }
  
  var lineWidth: CGFloat {
    switch self {
    case .barProgress: return 2.0
    case .ringProgress, .sectorProgress: return 1.0
    default: fatalError("The value can't match this property")
    }
  }
  
  func circleRect(bounds: CGRect) -> CGRect {
    switch self {
    case .barProgress: return bounds
    case .ringProgress, .sectorProgress: return bounds.insetBy(dx: self.lineWidth / 2.0, dy: self.lineWidth / 2.0)
    default: fatalError("The value can't match this method")
    }
  }
}

#endif

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
