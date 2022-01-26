#if os(iOS) || os(tvOS)
import UIKit
import XCTest

extension UIImage {
  func tiffData(quality: Float = 1.0) -> Data? {
    let data = NSMutableData()
    guard let cgImage = self.cgImage,
          let destination = CGImageDestinationCreateWithData(data, "public.tiff" as CFString, 1, nil),
          let colorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)
    else {
      return nil
    }

    let context = CIContext()
    let ciImage = CIImage(cgImage: cgImage)
    guard let image = context.createCGImage(ciImage, from: ciImage.extent, format: .RGBAh, colorSpace: colorSpace) else {
      return nil
    }

    let options: NSDictionary = [
      kCGImageDestinationLossyCompressionQuality: quality,
      kCGImagePropertyTIFFCompression: 5, // LZW
    ]
    CGImageDestinationAddImage(destination, image, options)
    guard CGImageDestinationFinalize(destination) else { return nil }

    return data as Data
  }
}
#endif
