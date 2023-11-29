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
    @State var countries: [String] = []
    
    @State var totalEvolution: Dictionary<String,Int> = [:]
    @State var newEvolution: Dictionary<String,Int> = [:]
    @State var _max: [Int] = [0,0]
    
    @State var total: [DateResponse] = []
    @State var totalAvg: Float = 0.0
    
    @State var increasing: [DateResponse] = []
    @State var increasingAvg: Float = 0.0
    var limit: Int = 3
    
    var body: some View {
        ScrollView {
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
                        
                        Text("Promedio de casos nuevos: \(increasingAvg)")
                            .font(.caption)
                    }
                    
                    Spacer().frame(height: 16)
                }
                
                Group { // Sobre un país en específico...
                    HStack {
                        Text("Evolución mensual")
                            .font(.footnote)
                        
                        Spacer()
                        
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundColor(.gray)
                        
                        Picker(selection: $contentViewModel.countryParam) {
                            ForEach(countries, id: \.self) {
                                country in Text(country).tag(country)
                            }
                        } label: {
                            Text("Selecciona un país")
                        }.onChange(of: contentViewModel.countryParam) {
                            tag in Task {
                                await contentViewModel.getCountryList()
                                updateMonthlyEvolution()
                            }
                         }
                    }.padding([.top, .bottom], 4)
                     .padding([.leading, .trailing], 8)
                     .background(Color(UIColor.systemGray6))
                    
                    Spacer().frame(height: 4)
                    
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        
                        Text("Año: \(String(contentViewModel.dateParam.prefix(4)))")
                            .font(.caption)
                    }
                    
                    Spacer().frame(height: 4)
                    
                    Text("Nuevos casos")
                        .font(.headline)
                        .frame(alignment: .leading)
                    
                    if(contentViewModel.countryList.count == 0) {
                        Text("Cargando estadísticas...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else if(newEvolution == [:]) {
                        Text("No hay estadísticas disponibles al momento.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    ForEach(newEvolution.sorted(by: <), id: \.key) {
                        key, value in HStack {
                            Text(key)
                                .font(.caption)
                            
                            Spacer().frame(width: 4)
                            
                            VStack {
                                GeometryReader {
                                    geometry in Text("\(value)")
                                        .font(.caption)
                                        .frame(width: CGFloat(value) / CGFloat(_max[1]) * geometry.size.width)
                                         .background(.blue)
                                }
                            }
                        }
                    }
                    
                    Text("Casos emergentes")
                        .font(.headline)
                        .frame(alignment: .leading)
                    
                    if(contentViewModel.countryList.count == 0) {
                        Text("Cargando estadísticas...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else if(totalEvolution == [:]) {
                        Text("No hay estadísticas disponibles al momento.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    ForEach(totalEvolution.sorted(by: <), id: \.key) {
                        key, value in HStack {
                            Text(key)
                                .font(.caption)
                            
                            Spacer().frame(width: 4)
                            
                            VStack {
                                GeometryReader {
                                    geometry in Text("\(value)")
                                        .font(.caption)
                                        .frame(width: CGFloat(value) / CGFloat(_max[0]) * geometry.size.width)
                                         .background(.blue)
                                }
                            }
                        }
                    }
                }
            }.padding()
             .frame(maxWidth: .infinity)
             .onAppear {
                Task {
                    await contentViewModel.getCountriesList()
                    await contentViewModel.getCountryList()
                    top()
                    statistics()
                    updateMonthlyEvolution()
                }
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
        increasingAvg = 0.0
        
        for record in contentViewModel.countriesList {
            totalAvg += Float(record.cases.total)
            increasingAvg += Float(record.cases.new)
            
            if(!countries.contains(record.country)) {
                countries.append(record.country)
            }
        }
        
        totalAvg /= Float(contentViewModel.countriesList.count)
        increasingAvg /= Float(contentViewModel.countriesList.count)
    }
    
    func updateMonthlyEvolution() {
        totalEvolution = [:]
        newEvolution = [:]
        _max = [0,0] // [total,new]
        
        for record in contentViewModel.countryList[0].cases {
            if(record.key.prefix(4) == contentViewModel.dateParam.prefix(4)) {
                let monthKey = String(record.key.suffix(5).prefix(2))
                
                // total records
                if(!totalEvolution.keys.contains(monthKey)) {
                    totalEvolution[monthKey] = record.value.total
                } else {
                    totalEvolution[monthKey]! += record.value.total
                }
                
                if(totalEvolution[monthKey]! > _max[0]) {
                    _max[0] = totalEvolution[monthKey]!
                }
                
                // new records
                if(!newEvolution.keys.contains(monthKey)) {
                    newEvolution[monthKey] = record.value.new
                } else {
                    newEvolution[monthKey]! += record.value.new
                }
                
                if(newEvolution[monthKey]! > _max[1]) {
                    _max[1] = newEvolution[monthKey]!
                }
            }
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
