//
//  ContentView.swift
//  COVID
//
//  Created by Ramona NF on 23/11/23.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel() // Vigilar el estado de una variable observable
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                Task {
                    await contentViewModel.getCountriesList()
                }
            }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
