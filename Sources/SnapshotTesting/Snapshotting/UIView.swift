#if os(iOS) || os(tvOS)
import UIKit

extension Snapshotting where Value == UIView, Format == UIImage {
  /// A snapshot strategy for comparing views based on pixel equality.
  public static var image: Snapshotting {
    return .image()
  }

  /// A snapshot strategy for comparing views based on pixel equality.
  ///
  /// - Parameters:
  ///   - drawHierarchyInKeyWindow: Utilize the simulator's key window in order to render `UIAppearance` and `UIVisualEffect`s. This option requires a host application for your tests and will _not_ work for framework test targets.
  ///   - precision: The percentage of pixels that must match.
  ///   - size: A view size override.
  ///   - traits: A trait collection override.
  public static func image(
    drawHierarchyInKeyWindow: Bool = false,
    precision: Float = 1,
    size: CGSize? = nil,
    traits: UITraitCollection = .init()
  )
  -> Snapshotting {
    return SimplySnapshotting.image(precision: precision, scale: traits.displayScale).asyncPullback { view in
      snapshotView(
        config: .init(safeArea: .zero, size: size ?? view.frame.size, traits: .init()),
        drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
        traits: traits,
        view: view,
        viewController: .init()
      )
    }
  }

  /// A snapshot strategy for comparing views based on pixel equality using HEIC.
  public static var imageHEIC: Snapshotting {
    return .imageHEIC()
  }

  /// A snapshot strategy for comparing views based on pixel equality using HEIC.
  ///
  /// - Parameters:
  ///   - drawHierarchyInKeyWindow: Utilize the simulator's key window in order to render `UIAppearance` and `UIVisualEffect`s. This option requires a host application for your tests and will _not_ work for framework test targets.
  ///   - precision: The percentage of pixels that must match.
  ///   - size: A view size override.
  ///   - traits: A trait collection override.
  ///   - quality: Compression quality: 1.0 == lossless, 0.0 == maximum compression
  public static func imageHEIC(
    drawHierarchyInKeyWindow: Bool = false,
    precision: Float = 1,
    size: CGSize? = nil,
    traits: UITraitCollection = .init(),
    quality: CGFloat = 1.0
  )
  -> Snapshotting {
    return SimplySnapshotting.imageHEIC(precision: precision, scale: traits.displayScale, quality: quality).asyncPullback { view in
      snapshotView(
        config: .init(safeArea: .zero, size: size ?? view.frame.size, traits: .init()),
        drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
        traits: traits,
        view: view,
        viewController: .init()
      )
    }
  }
}

extension Snapshotting where Value == UIView, Format == String {
  /// A snapshot strategy for comparing views based on a recursive description of their properties and hierarchies.
  public static var recursiveDescription: Snapshotting {
    return Snapshotting.recursiveDescription()
  }

  /// A snapshot strategy for comparing views based on a recursive description of their properties and hierarchies.
  public static func recursiveDescription(
    size: CGSize? = nil,
    traits: UITraitCollection = .init()
  )
  -> Snapshotting<UIView, String> {
    return SimplySnapshotting.lines.pullback { view in
      let dispose = prepareView(
        config: .init(safeArea: .zero, size: size ?? view.frame.size, traits: traits),
        drawHierarchyInKeyWindow: false,
        traits: .init(),
        view: view,
        viewController: .init()
      )
      defer { dispose() }
      return purgePointers(
        view.perform(Selector(("recursiveDescription"))).retain().takeUnretainedValue()
        as! String
      )
    }
  }
}
#endif
