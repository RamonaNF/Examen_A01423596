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
    @State var total: [DateResponse] = []
    @State var totalAvg: Int = 0
    
    @State var increasing: [DateResponse] = []
    @State var increatingAvg: Int = 0
    var limit: Int = 3
    
    var body: some View {
        VStack {
            Group {
                Text("Registros analizados: \(contentViewModel.countriesList.count)")
                    .font(.footnote)
                    .frame(alignment: .leading)
                
                Text("Fecha: \(contentViewModel.dateParam)")
                    .font(.footnote)
                    .frame(alignment: .leading)
                
                Spacer().frame(height: 16)
            }
            
            Group {
                Text("Más casos registrados")
                    .font(.headline)
                    .frame(alignment: .leading)
                
                if(total.count == 0) {
                    Text("Cargando estadísticas...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(0..<(limit < total.count ? limit : total.count)) {
                        i in Text("\(total[i].cases.total) casos en \(total[i].country)")
                            .font(.body)
                    }
                }
                
                Text("El promedio de casos es de \(totalAvg)")
                    .font(.caption)
                
                Spacer().frame(height: 16)
            }
            
            Group {
                Text("Apariciones en aumento")
                    .font(.headline)
                    .frame(alignment: .leading)
                
                if(increasing.count == 0) {
                    Text("Cargando estadísticas...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(0..<(limit < increasing.count ? limit : increasing.count)) {
                        i in Text("\(increasing[i].cases.total) nuevos casos en \(increasing[i].country)")
                            .font(.body)
                    }
                }
                
                Text("El promedio de casos nuevos es de \(totalAvg)")
                    .font(.caption)
                
                Spacer()
            }
            
            Text("1341687 nuevos casos en Mexico")
                .font(.footnote)
            Text("Canada")
                .font(.subheadline)
            Text("1341687 nuevos casos en Quebec")
                .font(.footnote)
            
        }.padding()
         .frame(maxWidth: .infinity)
         /*.onAppear {
            Task {
                await contentViewModel.getCountriesList()
                top()
            }
        }*/
    }
    
    func top() {
        // Más casos registrados
        total = contentViewModel.countriesList.sorted(by: { $0.cases.total > $1.cases.total })
        
        // Apariciones en aumento
        increasing = contentViewModel.countriesList.sorted(by: { $0.cases.new > $1.cases.new })
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
