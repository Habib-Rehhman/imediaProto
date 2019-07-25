

import UIKit

extension UIImage {
  func thumbnailOfSize(_ newSize: CGSize) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: newSize)
    let thumbnail = renderer.image {_ in
      self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
    }
    return thumbnail
  }
}
