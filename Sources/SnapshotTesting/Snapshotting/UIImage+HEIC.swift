#if os(iOS) || os(tvOS)
import AVFoundation
import UIKit

extension UIImage {
  func heicData(quality: CGFloat = 1.0) -> Data? {
    let data = NSMutableData()
    guard let destination = CGImageDestinationCreateWithData(data, AVFileType.heic as CFString, 1, nil) else { return nil }
    guard let cgImage = cgImage else { return nil }

    let options: NSDictionary = [
      kCGImageDestinationLossyCompressionQuality: quality
    ]
    CGImageDestinationAddImage(destination, cgImage, options)
    guard CGImageDestinationFinalize(destination) else { return nil }
    return data as Data
  }
}
#endif
