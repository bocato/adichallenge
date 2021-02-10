// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureModules",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "FeatureModules",
            type: .dynamic,
            targets: [
                "Products"
            ]
        ),
    ],
    dependencies: [
        .package(path: "CoreModules"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "0.14.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.8.2"
        )
    ],
    targets: [
        .target(
            name: "Products",
            dependencies: [
                "CoreUI",
                "RepositoryInterface",
                "SwiftUIViewProviderInterface"
            ]
        ),
        .testTarget(
            name: "ProductsTests",
            dependencies: [
                "Products"
            ]
        ),
    ]
)
