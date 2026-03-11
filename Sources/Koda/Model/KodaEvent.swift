//
//  KodaEvent.swift
//  Koda
//
//  Created by João Vitor Duarte Mariucio on 10/03/26.
//
import Foundation

public struct KodaEvent: Sendable {

    public let name: String
    public let parameters: [String: any Sendable]?
    public let userId: String?
    public let anonymousId: String
    public let timestamp: Date

    public init(
        name: String,
        parameters: [String: any Sendable]? = nil,
        userId: String? = nil,
        anonymousId: String,
        timestamp: Date = Date()
    ) {
        self.name = name
        self.parameters = parameters
        self.userId = userId
        self.anonymousId = anonymousId
        self.timestamp = timestamp
    }
}
