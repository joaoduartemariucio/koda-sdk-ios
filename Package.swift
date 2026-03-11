// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
//  Created by João Vitor Duarte Mariucio on 10/03/26.

import PackageDescription

let package = Package(
    name: "Koda",
    platforms: [
        .iOS(.v26), .macOS(.v26),
    ],
    products: [
        .library(
            name: "Koda",
            targets: ["Koda"]
        ),
        .library(
            name: "KodaFirebase",
            targets: ["KodaFirebase"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "Koda",
            path: "Sources/Koda",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .target(
            name: "KodaFirebase",
            dependencies: [
                "Koda",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/KodaFirebase"
        ),
        .testTarget(
            name: "KodaTests",
            dependencies: ["Koda"],
            path: "Tests/KodaTests"
        ),
    ],
    swiftLanguageModes: [.v6]
)
