//
//  ContentRequirement.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import Foundation

protocol CovidRequirementProtocol {
    func getRecordsByDate(dateParam: String) async -> [DateResponse]
    func getRecordsByCountry(countryParam: String) async -> [CountryResponse]
}

class CovidRequirement: CovidRequirementProtocol {
    static let shared = CovidRequirement() // Singleton
    let dataRepository: CovidRepository // Uso de un singleton

    init(dataRepository: CovidRepository = CovidRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getRecordsByDate(dateParam: String) async -> [DateResponse] {
        return await dataRepository.getRecordsByDate(dateParam: dateParam)
    }
    
    func getRecordsByCountry(countryParam: String) async -> [CountryResponse] {
        return await dataRepository.getRecordsByCountry(countryParam: countryParam)
    }
}
