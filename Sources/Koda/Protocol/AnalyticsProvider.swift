//
//  AnalyticsProvider.swift
//  Koda
//
//  Created by João Vitor Duarte Mariucio on 10/03/26.
//

public protocol AnalyticsProvider: Sendable {
    var name: String { get }

    func logEvent(name: String, parameters: [String: Any]?)
    func setUserProperty(_ value: String?, forName name: String)
    func setUserId(_ userId: String?)
    func logScreen(name: String, className: String, parameters: [String: Any]?)

    func setDefaultParameters(_ parameters: [String: Any]?)
    func resetData()
    func setCollectionEnabled(_ isEnabled: Bool)
}
