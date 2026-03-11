# Koda

Koda is an analytics SDK for iOS/macOS that centralizes instrumentation in a single place. It was created to reduce vendor coupling, standardize events, and allow swapping/combining providers without rewriting the application.

## Why it exists

In apps with multiple areas and teams, it is common for each product to adopt a different provider. This creates inconsistencies, duplicated events, and makes it hard to evolve the data strategy. Koda solves this by offering:

- A single API for events, screens, and user properties.
- Support for multiple providers in parallel.
- Concurrency-safe implementation (actor).

## What it aims to achieve

- Standardize instrumentation across the app.
- Make it easy to switch analytics providers.
- Allow multiple providers running at the same time.
- Simplify enabling/disabling collection and data reset.

## Installation (Swift Package Manager)

Add the package to your project and include the products `Koda` and, if you want Firebase, `KodaFirebase`.

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/joaoduartemariucio/koda-sdk-ios.git", from: "1.0.0")
],
```

> Note: the available products are `Koda`, `KodaFirebase`, and `KodaProviders`.

## Single import (all providers)

If you prefer a single import as the number of integrations grows, use the aggregate product `KodaProviders`. It re-exports the core `Koda` module and all available provider modules.

```swift
import KodaProviders
```

## Basic usage

### 1) Register providers

Register providers as early as possible (e.g., in `App` or `AppDelegate`). Since `Koda` is an actor, calls should use `await`.

```swift
import KodaProviders

@main
struct MyApp: App {
    init() {
        Task {
            await Koda.shared.register(provider: FirebaseAnalyticsProvider())
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2) Log a screen

```swift
Task {
    await Koda.shared.logScreen(name: "Home", className: "HomeView", parameters: [
        "ab_test": "v1"
    ])
}
```

### 3) User properties and user id

```swift
Task {
    await Koda.shared.setUserId("user-123")
    await Koda.shared.setUserProperty("pro", forName: "plan")
}
```

### 4) Default parameters

```swift
Task {
    await Koda.shared.setDefaultParameters([
        "app_version": "1.0.0",
        "platform": "ios"
    ])
}
```

### 5) Enable/disable collection and reset

```swift
Task {
    await Koda.shared.setAnalyticsCollectionEnabled(true)
    await Koda.shared.resetData()
}
```

### 6) App Tracking Transparency (ATT)

If you need to request tracking permission, use the call below. If the status is already determined, it does nothing.

```swift
Task {
    await Koda.shared.requestTrackingPermissionIfNeeded()
}
```

### 7) Custom events

Use `Koda.shared.log(_:)` with a `KodaEvent`. The model includes `name`, `parameters`, `userId`, `anonymousId`, and `timestamp`. It is recommended to create a wrapper in your app to standardize event names and parameters.

## Firebase (already integrated)

Firebase support is already integrated via the `KodaFirebase` product. To use it:

1. Add the `KodaFirebase` product to your app target.
2. Configure Firebase according to the official documentation (e.g., `FirebaseApp.configure()`).
3. Register the `FirebaseAnalyticsProvider` provider in Koda.

## Provider roadmap

The top 5 analytics libraries are being implemented. Current status:

- Firebase Analytics (integrated)
- Amplitude (in progress)
- Mixpanel (in progress)
- Segment (in progress)
- AppsFlyer (in progress)

## SDK structure

- `Koda`: main API and provider management.
- `AnalyticsProvider`: protocol that any provider must implement.
- `KodaFirebase`: official Firebase implementation.
