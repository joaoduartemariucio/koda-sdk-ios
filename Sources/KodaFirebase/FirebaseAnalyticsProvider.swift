//
//  FirebaseAnalyticsProvider.swift
//  Koda
//
//  Created by João Vitor Duarte Mariucio on 10/03/26.
//

import FirebaseAnalytics
import Foundation
import Koda

public final class FirebaseAnalyticsProvider: AnalyticsProvider, @unchecked Sendable {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public let name = "Firebase"

    public func logEvent(name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }

    public func logScreen(name: String, className: String = "View", parameters: [String: Any]? = nil) {
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

    public func setDefaultParameters(_ parameters: [String: Any]?) {
        Analytics.setDefaultEventParameters(parameters)
    }

    public func resetData() {
        Analytics.resetAnalyticsData()
    }

    public func setCollectionEnabled(_ isEnabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(isEnabled)
    }
}
