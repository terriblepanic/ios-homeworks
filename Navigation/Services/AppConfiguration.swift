//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/21/26.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people/8"
    case starships = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"
    
    var url: URL? {
        URL(string: self.rawValue)
    }
}
