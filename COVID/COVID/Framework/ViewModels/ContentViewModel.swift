//
//  ContentViewModel.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import Foundation

class ContentViewModel: ObservableObject { // Emite cambios de sus valores
    @Published var countriesList = [DateResponse]() // Notifica cambios al ContentView
    @Published var dateParam = "2022-01-01"
    
    @Published var countryList = [CountryResponse]()
    @Published var countryParam = "Mexico"
    
    var covidRequirement: CovidRequirement

    init(covidRequirement: CovidRequirement = CovidRequirement.shared) {
        self.covidRequirement = covidRequirement
    }
    
    @MainActor // Singleton del OS para que el método corra en el mainQueue
    func getCountriesList() async {
        countriesList = await covidRequirement.getRecordsByDate(dateParam: dateParam)
        //print(countriesList)
    }
    
    @MainActor // Singleton del OS para que el método corra en el mainQueue
    func getCountryList() async {
        countryList = await covidRequirement.getRecordsByCountry(countryParam: countryParam)
        //print(countryList)
    }
}
