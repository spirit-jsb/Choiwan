// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Choiwan",
  platforms: [
    .iOS(.v10)
  ],
  products: [
    .library(name: "Choiwan", targets: ["Choiwan"]),
  ],
  targets: [
    .target(name: "Choiwan", path: "Sources"),
  ],
  swiftLanguageVersions: [
    .v5
  ]
)

