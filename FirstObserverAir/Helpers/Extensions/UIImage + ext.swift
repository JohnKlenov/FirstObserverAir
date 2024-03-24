//
//  UIImage + ext.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 24.03.24.
//

import UIKit

extension UIImage {
  func thumbnailOfSize(_ newSize: CGSize) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: newSize)
    let thumbnail = renderer.image { _ in
      draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
    }
    return thumbnail
  }
}
