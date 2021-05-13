// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum PokemonType {
    internal enum CircularIcons {
      internal static let bug = ImageAsset(name: "Bug")
      internal static let dark = ImageAsset(name: "Dark")
      internal static let dragon = ImageAsset(name: "Dragon")
      internal static let electric = ImageAsset(name: "Electric")
      internal static let fairy = ImageAsset(name: "Fairy")
      internal static let fighting = ImageAsset(name: "Fighting")
      internal static let fire = ImageAsset(name: "Fire")
      internal static let flying = ImageAsset(name: "Flying")
      internal static let ghost = ImageAsset(name: "Ghost")
      internal static let grass = ImageAsset(name: "Grass")
      internal static let ground = ImageAsset(name: "Ground")
      internal static let ice = ImageAsset(name: "Ice")
      internal static let normal = ImageAsset(name: "Normal")
      internal static let poison = ImageAsset(name: "Poison")
      internal static let psychic = ImageAsset(name: "Psychic")
      internal static let rock = ImageAsset(name: "Rock")
      internal static let steel = ImageAsset(name: "Steel")
      internal static let water = ImageAsset(name: "Water")
    }
    internal enum Color {
      internal static let bug = ColorAsset(name: "Bug")
      internal static let dark = ColorAsset(name: "Dark")
      internal static let dragon = ColorAsset(name: "Dragon")
      internal static let electric = ColorAsset(name: "Electric")
      internal static let fairy = ColorAsset(name: "Fairy")
      internal static let fighting = ColorAsset(name: "Fighting")
      internal static let fire = ColorAsset(name: "Fire")
      internal static let flying = ColorAsset(name: "Flying")
      internal static let ghost = ColorAsset(name: "Ghost")
      internal static let grass = ColorAsset(name: "Grass")
      internal static let ground = ColorAsset(name: "Ground")
      internal static let ice = ColorAsset(name: "Ice")
      internal static let normal = ColorAsset(name: "Normal")
      internal static let poison = ColorAsset(name: "Poison")
      internal static let psychic = ColorAsset(name: "Psychic")
      internal static let rock = ColorAsset(name: "Rock")
      internal static let steel = ColorAsset(name: "Steel")
      internal static let water = ColorAsset(name: "Water")
    }
    internal enum RectangularIcons {
      internal static let bug = ImageAsset(name: "Bug")
      internal static let dark = ImageAsset(name: "Dark")
      internal static let dragon = ImageAsset(name: "Dragon")
      internal static let electric = ImageAsset(name: "Electric")
      internal static let fairy = ImageAsset(name: "Fairy")
      internal static let fighting = ImageAsset(name: "Fighting")
      internal static let fire = ImageAsset(name: "Fire")
      internal static let flying = ImageAsset(name: "Flying")
      internal static let ghost = ImageAsset(name: "Ghost")
      internal static let grass = ImageAsset(name: "Grass")
      internal static let ground = ImageAsset(name: "Ground")
      internal static let ice = ImageAsset(name: "Ice")
      internal static let normal = ImageAsset(name: "Normal")
      internal static let poison = ImageAsset(name: "Poison")
      internal static let psychic = ImageAsset(name: "Psychic")
      internal static let rock = ImageAsset(name: "Rock")
      internal static let steel = ImageAsset(name: "Steel")
      internal static let water = ImageAsset(name: "Water")
    }
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
