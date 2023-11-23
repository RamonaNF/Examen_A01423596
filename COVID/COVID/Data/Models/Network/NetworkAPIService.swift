//
//  NetworkAPIService.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import Foundation
import Alamofire // AF

class NetworkAPIService {
    // Singleton: Proporciona un único acceso a la instancia de un objeto
    static let shared = NetworkAPIService()

    // Obtener respuesta de la API
    func getAPIinfo(url: URL, params: Parameters) async -> [DateResponse] {
        let headers: HTTPHeaders = [
            "X-Api-Key": "wLVPN1zV08lJYF7uXqgyPw==zVwp6TlVcAO1NLUf"
        ]
        
        do {
            // Petición y manejo de error o éxito en la respuesta
            return try await withCheckedThrowingContinuation {
                continuation in AF.request(url, method: .get, parameters: params, headers: headers)
                    .responseDecodable(of: [DateResponse].self) {
                        response in switch response.result {
                            case .success(let data):
                                //print("SUCCESS", data)
                                continuation.resume(returning: data)
                                
                            case .failure(let error):
                                debugPrint(error.localizedDescription)
                                continuation.resume(throwing: NSError())
                        }
                    }
            }
        } catch {
            debugPrint("Error NetworkAPIService")
        }
        
        return []
    }
}
