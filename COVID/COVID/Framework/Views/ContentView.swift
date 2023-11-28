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
    @State var totalAvg: Float = 0.0
    
    @State var increasing: [DateResponse] = []
    @State var increatingAvg: Float = 0.0
    var limit: Int = 3
    
    var body: some View {
        VStack (spacing: 4) {
            Group { // Información general
                HStack {
                    Text("Regiones analizadas: \(contentViewModel.countriesList.count)")
                        .font(.footnote)
                        .frame(alignment: .leading)
                    
                    Image(systemName: "globe.americas")
                        .foregroundColor(.green)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    
                    Text("Fecha: \(contentViewModel.dateParam)")
                        .font(.footnote)
                        .frame(alignment: .leading)
                }
                
                Spacer().frame(height: 16)
            }
            
            Group { // Sobre el total de casos...
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    
                    Text("Más casos registrados")
                        .font(.headline)
                        .frame(alignment: .leading)
                }
                
                if(total.count == 0) {
                    Text("Cargando estadísticas...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(0..<(limit < total.count ? limit : total.count)) {
                        i in Text("\(total[i].cases.total) casos en \(total[i].region + (total[i].region == "" ? "" : ", "))\(total[i].country)")
                            .font(.footnote)
                    }
                }
                
                Spacer().frame(height: 8)
                
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    
                    Text("Promedio de casos: \(totalAvg)")
                        .font(.caption)
                }
                
                Spacer().frame(height: 16)
            }
            
            Group { // Sobre los nuevos casos...
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    
                    Text("Apariciones en aumento")
                        .font(.headline)
                        .frame(alignment: .leading)
                }
                
                if(increasing.count == 0) {
                    Text("Cargando estadísticas...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(0..<(limit < increasing.count ? limit : increasing.count)) {
                        i in Text("\(increasing[i].cases.new) casos nuevos en \(increasing[i].region + (increasing[i].region == "" ? "" : ", "))\(increasing[i].country)")
                            .font(.footnote)
                    }
                }
                
                Spacer().frame(height: 8)
                
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    
                    Text("Promedio de casos nuevos: \(totalAvg)")
                        .font(.caption)
                }
            }
            
        }.padding()
         .frame(maxWidth: .infinity)
         .onAppear {
            Task {
                await contentViewModel.getCountriesList()
                top()
                statistics()
                await contentViewModel.getCountryList()
            }
        }
    }
    
    func top() {
        // Más casos registrados
        total = contentViewModel.countriesList.sorted(by: { $0.cases.total > $1.cases.total })
        
        // Apariciones en aumento
        increasing = contentViewModel.countriesList.sorted(by: { $0.cases.new > $1.cases.new })
    }
    
    func statistics() {
        totalAvg = 0.0
        increatingAvg = 0.0
        
        for record in contentViewModel.countriesList {
            totalAvg += Float(record.cases.total)
            increatingAvg += Float(record.cases.new)
        }
        
        totalAvg /= Float(contentViewModel.countriesList.count)
        increatingAvg = Float(contentViewModel.countriesList.count)
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
