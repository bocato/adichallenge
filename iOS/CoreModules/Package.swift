// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreModules",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CoreModules",
            type: .dynamic,
            targets: [
                "NetworkingInterface",
                "Networking",
                "RepositoryInterface",
                "Repository",
                "SwiftUIViewProviderInterface",
                "SwiftUIViewProvider",
                "CoreUI"
            ]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // MARK: - Networking Module
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
        
        // MARK: - Repository Module
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
        
        // MARK: - SwiftUIViewProvider Module
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
        
        // MARK: - CoreUI Module
        .target(
            name: "CoreUI",
            dependencies: []
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: [
                "CoreUI"
            ]
        ),
    ]
)
