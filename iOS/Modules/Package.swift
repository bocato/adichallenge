// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules", // TODO: - This should be splitted into FeatureModules (that depends on Core) and CoreModules
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Modules",
            type: .dynamic,
            targets: [
                // Core Modules
                "FoundationKit",
                "CoreUI",
                "NetworkingInterface",
                "Networking",
                "RepositoryInterface",
                "Repository",
                "SwiftUIViewProviderInterface",
                "SwiftUIViewProvider",

                // Feature Modules
                "Feature-Products",
            ]
        ),
    ],
    dependencies: [
        // MARK: - Third Party

        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "0.9.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.8.2"
        ),
    ],
    targets: [
        // MARK: - Core Modules

        // FoundationKit Module
        .target(
            name: "FoundationKit",
            dependencies: []
        ),
        .testTarget(
            name: "FoundationKitTests",
            dependencies: []
        ),

        // CoreUI Module
        .target(
            name: "CoreUI",
            dependencies: [
                "FoundationKit",
            ],
            resources: [
                .process("Resources/Localizable.strings"),
            ]
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: [
                "CoreUI",
            ]
        ),

        // Networking Module
        .target(
            name: "NetworkingInterface",
            dependencies: []
        ),
        .target(
            name: "Networking",
            dependencies: [
                "NetworkingInterface",
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: [
                "NetworkingInterface",
                "Networking",
            ]
        ),

        // Repository Module
        .target(
            name: "RepositoryInterface",
            dependencies: [
                "NetworkingInterface",
            ]
        ),
        .target(
            name: "Repository",
            dependencies: [
                "NetworkingInterface",
                "RepositoryInterface",
                "CacheKit",
            ]
        ),
        .testTarget(
            name: "RepositoryTests",
            dependencies: [
                "NetworkingInterface",
                "RepositoryInterface",
                "Repository",
                "CacheKit",
            ]
        ),

        // SwiftUIViewProvider Module
        .target(
            name: "SwiftUIViewProviderInterface",
            dependencies: []
        ),
        .target(
            name: "SwiftUIViewProvider",
            dependencies: [
                "SwiftUIViewProviderInterface",
            ]
        ),
        .testTarget(
            name: "SwiftUIViewProviderTests",
            dependencies: [
                "SwiftUIViewProviderInterface",
                "SwiftUIViewProvider",
            ]
        ),

        // CacheKit Module
        .target(
            name: "CacheKit",
            dependencies: []
        ),
        .testTarget(
            name: "CacheKitTests",
            dependencies: [
                "CacheKit",
            ]
        ),

        // MARK: - Feature Modules

        .target(
            name: "Feature-Products",
            dependencies: [
                // Internal Dependencies
                "CoreUI",
                "RepositoryInterface",
                "SwiftUIViewProviderInterface",
                // Third Party Dependencies
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources/Localizable.strings"),
            ]
        ),
        .testTarget(
            name: "Feature-ProductsTests",
            dependencies: [
                "Feature-Products",
            ]
        ),
    ]
)
