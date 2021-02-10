// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules", // TODO: - This should be splitted into FeatureModules (that depends on Core) and CoreModules
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Modules",
            type: .dynamic,
            targets: [
                // Core Modules
                "CoreFoundation",
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
            from: "0.14.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.8.2"
        )
    ],
    targets: [
        // MARK: - Core Modules
        
        // CoreFoundation Module
        .target(
            name: "CoreFoundation",
            dependencies: []
        ),
        .testTarget(
            name: "CoreFoundationTests",
            dependencies: []
        ),
        
        // CoreUI Module
        .target(
            name: "CoreUI",
            dependencies: [
                "CoreFoundation"
            ]
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: [
                "CoreUI"
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
                "NetworkingInterface"
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: [
                "NetworkingInterface",
                "Networking"
            ]
        ),
        
        // Repository Module
        .target(
            name: "RepositoryInterface",
            dependencies: [
                "NetworkingInterface"
            ]
        ),
        .target(
            name: "Repository",
            dependencies: [
                "NetworkingInterface",
                "RepositoryInterface"
            ]
        ),
        .testTarget(
            name: "RepositoryTests",
            dependencies: [
                "NetworkingInterface",
                "RepositoryInterface",
                "Repository"
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
                "SwiftUIViewProviderInterface"
            ]
        ),
        .testTarget(
            name: "SwiftUIViewProviderTests",
            dependencies: [
                "SwiftUIViewProviderInterface",
                "SwiftUIViewProvider"
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
                "ComposableArchitecture"
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
