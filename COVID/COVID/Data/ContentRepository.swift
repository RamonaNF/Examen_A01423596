//
//  ContentRepository.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import Foundation

//  Protocolo del servicio de API
protocol CovidAPIProtocol { //  Mapear API (conexiones, URLs necesarias) -> BAAS (backend as a service)
    // POST: body de la petición HTTP (decodificado dentro del paquete)
    // GET: query como parámetro
    
    // async func: porque el método podría tomar mucho tiempo en devolver la información
    
    // https://api.api-ninjas.com/v1/covid19?date=2022-01-01
    func getRecordsByDate(dateParam: String) async -> [DateResponse]
    
    // https://api.api-ninjas.com/v1/covid19?country=Mexico
    func getRecordsByCountry(countryParam: String) async -> [CountryResponse]
}


// Rutas
struct Api {
    static let base = "https://api.api-ninjas.com/v1" // URL base
    
    struct routes {
        static let root = "/covid19" // Módulo de la API
    }
}


class CovidRepository: CovidAPIProtocol { // Se hereda del protocolo
    let nservice: NetworkAPIService // Uso del singleton
    static let shared = CovidRepository()
    
    // Para que en cada acceso al repo por default se use el singleton de nuestra API
    init(nservice: NetworkAPIService = NetworkAPIService.shared) { // Asigna parámetro por default
        self.nservice = nservice
    }
    
    func getRecordsByDate(dateParam: String) async -> [DateResponse] {
        let params: [String:String] = [
            "date": dateParam
        ]
        
        return await nservice.getAPIinfo(url: URL(string:"\(Api.base)\(Api.routes.root)")!, params: params)
    }
    
    func getRecordsByCountry(countryParam: String) async -> [CountryResponse] {
        let params: [String:String] = [
            "country": countryParam
        ]
        
        return await nservice.getAPIinfo(url: URL(string:"\(Api.base)\(Api.routes.root)")!, params: params)
    }
}
