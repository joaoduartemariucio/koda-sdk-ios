//
//  Koda.swift
//  Koda
//
//  Created by João Vitor Duarte Mariucio on 10/03/26.
//

import AppTrackingTransparency
import Foundation

/// Entry point for logging analytics events through registered providers.
///
/// `Koda` is an actor to keep provider access thread-safe. Use the shared
/// instance to register providers and log events.
public actor Koda {

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Public

    /// Shared singleton instance used by clients.
    public static let shared = Koda()

    /// Registers an analytics provider to receive events.
    /// - Parameter provider: The provider that will handle analytics calls.
    public func register(provider: some AnalyticsProvider) {
        providers.append(provider)
    }

    /// Logs a custom analytics event.
    /// - Parameter event: The event to be logged.
    public func log(_ event: KodaEvent) {
        for provider in providers {
            provider.logEvent(name: event.name, parameters: event.parameters)
        }
    }

    /// Logs a screen view.
    /// - Parameters:
    ///   - name: The screen name.
    ///   - className: The screen class name. Defaults to `"View"`.
    ///   - parameters: Optional additional parameters.
    public func logScreen(name: String, className: String = "View", parameters: [String: any Sendable]? = nil) {
        for provider in providers {
            provider.logScreen(name: name, className: className, parameters: parameters)
        }
    }

    /// Sets a user property value.
    /// - Parameters:
    ///   - value: The property value. Pass `nil` to clear it.
    ///   - name: The user property name.
    public func setUserProperty(_ value: String?, forName name: String) {
        for provider in providers {
            provider.setUserProperty(value, forName: name)
        }
    }

    /// Sets the user identifier.
    /// - Parameter userId: The user ID. Pass `nil` to clear it.
    public func setUserId(_ userId: String?) {
        for provider in providers {
            provider.setUserId(userId)
        }
    }

    /// Sets default parameters applied to all subsequent events.
    /// - Parameter parameters: The default parameters or `nil` to clear them.
    public func setDefaultParameters(_ parameters: [String: any Sendable]?) {
        for provider in providers {
            provider.setDefaultParameters(adaptedParameters)
        }
    }

    /// Resets analytics data on all providers.
    public func resetData() {
        for provider in providers {
            provider.resetData()
        }
    }

    /// Enables or disables analytics collection.
    /// - Parameter isEnabled: Whether analytics collection is enabled.
    public func setAnalyticsCollectionEnabled(_ isEnabled: Bool) {
        for provider in providers {
            provider.setCollectionEnabled(isEnabled)
        }
    }

    /// Requests App Tracking Transparency permission if the status is not determined.
    ///
    /// When the user responds, analytics collection is enabled only if authorization
    /// is granted. If the status is already determined, this call is a no-op.
    public func requestTrackingPermissionIfNeeded() async {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }

        let status = await ATTrackingManager.requestTrackingAuthorization()

        let isEnabled = (status == .authorized)

        for provider in providers {
            provider.setCollectionEnabled(isEnabled)
        }
    }

    // MARK: - Private

    private var providers: [any AnalyticsProvider] = []

}
