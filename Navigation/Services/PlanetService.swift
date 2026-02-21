//
//  PlanetService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/21/26.
//

import Foundation

enum PlanetError: Error {
    case invalidURL
    case dataIsNil
    case decodingError(Error)
    case networkError(Error)
}

struct PlanetService {
    
    static func fetchPlanet(id: Int = 1, completion: @escaping (Result<Planet, PlanetError>) -> Void) {
        let urlString = "https://swapi.dev/api/planets/\(id)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("\n[PlanetService] Запрос: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Обработка ошибки
            if let error = error {
                print("[PlanetService] Ошибка: \(error.localizedDescription)")
                completion(.failure(.networkError(error)))
                return
            }
            
            // Обработка данных
            guard let data = data else {
                print("[PlanetService] Нет данных")
                completion(.failure(.dataIsNil))
                return
            }
            
            // Декодирование
            do {
                let decoder = JSONDecoder()
                let planet = try decoder.decode(Planet.self, from: data)
                
                print("[PlanetService] Planet декодирован: \(planet.name)")
                print("[PlanetService] Orbital period: \(planet.orbitalPeriod)")
                completion(.success(planet))
                
            } catch {
                print("[PlanetService] Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
