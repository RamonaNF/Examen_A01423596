//
//  Content.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import Foundation

struct Case: Codable {
    var total: Int
    var new: Int
}

struct CountryResponse: Codable {
    var country: String
    var region: String
    var cases: [String: Case]
}

struct DateResponse: Codable {
    var country: String
    var region: String
    var cases: Case
}
