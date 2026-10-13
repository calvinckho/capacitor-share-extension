// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorShareExtension",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapacitorShareExtension",
            targets: ["CapacitorShareExtension"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "CapacitorShareExtension",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CapacitorShareExtension"
        ),
        .testTarget(
            name: "CapacitorShareExtensionTests",
            dependencies: ["CapacitorShareExtension"],
            path: "ios/Tests/CapacitorShareExtensionTests"
        )
    ]
)
