// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyWidgets",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftyWidgets",
            targets: ["SwiftyWidgets"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", branch: "https://github.com/Alamofire/Alamofire/tree/5.4.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftyWidgets",
            dependencies: [
                "Alamofire"
            ],
            resources: [
                .process("resources/CountryNumbers.json")
            ]
        ),
    ]
)
