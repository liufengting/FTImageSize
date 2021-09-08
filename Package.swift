// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "FTImageSize",
    platforms: [ .iOS(.v12), .macOS(.v10_14)],
    products: [
        .library(name: "FTImageSize", targets: ["FTImageSize"]),
    ],
    targets: [
        .target(name: "FTImageSize", path: "FTImageSize")
    ],
    swiftLanguageVersions: [.v5]
)
