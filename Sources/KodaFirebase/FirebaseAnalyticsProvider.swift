//
//  FirebaseAnalyticsProvider.swift
//  Koda
//
//  Created by João Vitor Duarte Mariucio on 10/03/26.
//

import FirebaseAnalytics
import Foundation
import Koda

public final class FirebaseAnalyticsProvider: AnalyticsProvider, Sendable {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public let name = "Firebase"

    public func logEvent(name: String, parameters: [String: any Sendable]?) {
        Analytics.logEvent(name, parameters: anyParameters(from: parameters))
    }

    public func logScreen(name: String, className: String = "View", parameters: [String: any Sendable]? = nil) {
        var payload: [String: Any] = [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: className
        ]

        if let extraParams = anyParameters(from: parameters) {
            for (key, value) in extraParams {
                payload[key] = value
            }
        }

        Analytics.logEvent(AnalyticsEventScreenView, parameters: payload)
    }

    public func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }

    public func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
    }

    public func setDefaultParameters(_ parameters: [String: any Sendable]?) {
        Analytics.setDefaultEventParameters(anyParameters(from: parameters))
    }

    public func resetData() {
        Analytics.resetAnalyticsData()
    }

    public func setCollectionEnabled(_ isEnabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(isEnabled)
    }

    // MARK: - Private

    /// Converts a `Sendable`-typed value to a Firebase-compatible primitive (`String` or `NSNumber`).
    /// Returns `nil` for unsupported types so they are silently dropped.
    private func firebaseCompatibleValue(_ value: any Sendable) -> Any? {
        if let v = value as? String { return v }
        // All Swift numeric types (Int, Double, Float, Bool, etc.) bridge to NSNumber.
        if let v = value as? NSNumber { return v }
        return nil
    }

    private func anyParameters(from parameters: [String: any Sendable]?) -> [String: Any]? {
        guard let parameters else { return nil }
        let converted = parameters.compactMapValues { firebaseCompatibleValue($0) }
        return converted.isEmpty ? nil : converted
    }
}
