//
//  KodaEvent.swift
//  Koda
//
//  Created by João Vitor Duarte Mariucio on 10/03/26.
//
import Foundation

public struct KodaEvent {

    let name: String
    let parameters: [String: Any]?
    let userId: String?
    let anonymousId: String
    let timestamp: Date
}
