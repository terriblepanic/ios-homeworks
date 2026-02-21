//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/21/26.
//

import Foundation

enum AppConfiguration {
    case people(String)
    case starships(String)
    case planets(String)
    
    var urlString: String {
        switch self {
        case .people(let id):
            return "https://swapi.dev/api/people/\(id)"
        case .starships(let id):
            return "https://swapi.dev/api/starships/\(id)"
        case .planets(let id):
            return "https://swapi.dev/api/planets/\(id)"
        }
    }
    
    var url: URL? {
        return URL(string: urlString)
    }
}
