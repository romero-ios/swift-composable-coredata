// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "swift-composable-coredata",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "ComposableCoreData",
      targets: ["ComposableCoreData"]
    ),
  ],
  targets: [
    .target(
      name: "ComposableCoreData"
    ),
    .testTarget(
      name: "ComposableCoreDataTests",
      dependencies: ["ComposableCoreData"]
    ),
  ]
)
