# Composable CoreData

This is `Composable CoreData`, a package that provides access to a default live implementation of a database that can create, read, update and delete models in the persistence container you provide it.

## Installation

### Swift Package Manager

You can add `Composable CoreData` as a dependency to your `Package.swift` file:

```swift
let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "git@github.com:romero-ios/swift-composable-coredata.git", from: "0.1.0"),
    ],
)
