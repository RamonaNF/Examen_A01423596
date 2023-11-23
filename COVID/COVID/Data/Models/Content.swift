//
//  Content.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import Foundation

/*struct CountryResponse: Decodable {
    var country: String
    var region: String
    var cases: [Case]
}*/

struct Case: Codable {
    var total: Int
    var new: Int
}

struct DateResponse: Decodable {
    var country: String
    var region: String
    var cases: Case
}
