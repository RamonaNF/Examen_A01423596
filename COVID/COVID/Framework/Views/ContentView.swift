//
//  ContentView.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    let nservice: NetworkAPIService
    
    init(nservice: NetworkAPIService = NetworkAPIService.shared) { // Asigna parámetro por default
        self.nservice = nservice
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                Task {
                    print(await nservice.getAPIinfo(url: URL(string:"https://api.api-ninjas.com/v1/covid19?date=2022-01-01")!))
                }
            }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
