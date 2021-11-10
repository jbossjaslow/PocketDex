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
  internal enum Pokeball {
    internal static let pokeballSmall = ImageAsset(name: "Pokeball-small")
    internal static let pokeball = ImageAsset(name: "Pokeball")
  }
  internal enum PokemonType {
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
    internal enum Icons {
      internal static let bugCircular = ImageAsset(name: "BugCircular")
      internal static let bugRectangular = ImageAsset(name: "BugRectangular")
      internal static let darkCircular = ImageAsset(name: "DarkCircular")
      internal static let darkRectangular = ImageAsset(name: "DarkRectangular")
      internal static let dragonCircular = ImageAsset(name: "DragonCircular")
      internal static let dragonRectangular = ImageAsset(name: "DragonRectangular")
      internal static let electricCircular = ImageAsset(name: "ElectricCircular")
      internal static let electricRectangular = ImageAsset(name: "ElectricRectangular")
      internal static let fairyCircular = ImageAsset(name: "FairyCircular")
      internal static let fairyRectangular = ImageAsset(name: "FairyRectangular")
      internal static let fightingCircular = ImageAsset(name: "FightingCircular")
      internal static let fightingRectangular = ImageAsset(name: "FightingRectangular")
      internal static let fireCircular = ImageAsset(name: "FireCircular")
      internal static let fireRectangular = ImageAsset(name: "FireRectangular")
      internal static let flyingCircular = ImageAsset(name: "FlyingCircular")
      internal static let flyingRectangular = ImageAsset(name: "FlyingRectangular")
      internal static let ghostCircular = ImageAsset(name: "GhostCircular")
      internal static let ghostRectangular = ImageAsset(name: "GhostRectangular")
      internal static let grassCircular = ImageAsset(name: "GrassCircular")
      internal static let grassRectangular = ImageAsset(name: "GrassRectangular")
      internal static let groundCircular = ImageAsset(name: "GroundCircular")
      internal static let groundRectangular = ImageAsset(name: "GroundRectangular")
      internal static let iceCircular = ImageAsset(name: "IceCircular")
      internal static let iceRectangular = ImageAsset(name: "IceRectangular")
      internal static let normalCircular = ImageAsset(name: "NormalCircular")
      internal static let normalRectangular = ImageAsset(name: "NormalRectangular")
      internal static let poisonCircular = ImageAsset(name: "PoisonCircular")
      internal static let poisonRectangular = ImageAsset(name: "PoisonRectangular")
      internal static let psychicCircular = ImageAsset(name: "PsychicCircular")
      internal static let psychicRectangular = ImageAsset(name: "PsychicRectangular")
      internal static let rockCircular = ImageAsset(name: "RockCircular")
      internal static let rockRectangular = ImageAsset(name: "RockRectangular")
      internal static let steelCircular = ImageAsset(name: "SteelCircular")
      internal static let steelRectangular = ImageAsset(name: "SteelRectangular")
      internal static let waterCircular = ImageAsset(name: "WaterCircular")
      internal static let waterRectangular = ImageAsset(name: "WaterRectangular")
    }
  }
  internal static let initialBackgroundColor = ColorAsset(name: "initialBackgroundColor")
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
