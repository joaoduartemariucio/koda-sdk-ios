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

        if let extraParams = parameters {
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

    private func anyParameters(from parameters: [String: any Sendable]?) -> [String: Any]? {
        parameters.map { Dictionary(uniqueKeysWithValues: $0.map { ($0.key, $0.value as Any) }) }
    }
}
