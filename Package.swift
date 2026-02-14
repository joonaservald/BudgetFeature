// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "BudgetFeature",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "BudgetFeature",
            targets: ["BudgetFeature"]
        ),
    ],
    targets: [
        .target(
            name: "BudgetFeature"
        ),
        .testTarget(
            name: "BudgetFeatureTests",
            dependencies: ["BudgetFeature"]
        ),
    ]
)
