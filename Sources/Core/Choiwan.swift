//
//  Choiwan.swift
//  Choiwan
//
//  Created by Max on 2021/2/26.
//

#if canImport(Foundation)

import Foundation

public enum VMHUDMode {
  case loading
  case barProgress
  case ringProgress
  case sectorProgress
  case custom
  case text
}

public enum VMHUDAnimation {
  case fade
  case zoom
  case zoomIn
  case zoomOut
}

public enum VMBackgroundStyle {
  case blur
  case solidColor
}

#endif
