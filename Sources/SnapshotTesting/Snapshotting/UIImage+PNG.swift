#if os(iOS) || os(tvOS)
import UIKit
import XCTest

extension UIImage {
  func pngData(colorSpace: CGColorSpace) -> Data? {
    let data = NSMutableData()
    guard let cgImage = self.cgImage,
          let destination = CGImageDestinationCreateWithData(data, "public.png" as CFString, 1, nil)
    else {
      return nil
    }

    let context = CIContext()
    let ciImage = CIImage(cgImage: cgImage)
    guard let image = context.createCGImage(ciImage, from: ciImage.extent, format: .RGBA16, colorSpace: colorSpace) else {
      return nil
    }

    let options: NSDictionary = [:]
    CGImageDestinationAddImage(destination, image, options)
    guard CGImageDestinationFinalize(destination) else { return nil }

    return data as Data
  }
}
#endif
