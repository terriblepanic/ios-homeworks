//
//  NetworkService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/21/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case errorAnswerCode(Int)
    case dataIsNil
    case networkError(Error)
    case jsonParsingError(Error)
}

struct NetworkService {
    
    static func request(
        for configuration: AppConfiguration,
        completion: ((Result<[String: Any], NetworkError>) -> Void)?
    ) {
        guard let url = configuration.url else {
            completion?(.failure(.invalidURL))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            
            // Обработка ошибки
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                print("Debug: \(error)")
                completion?(.failure(.networkError(error)))
                return
            }
            
            // Обработка response
            if let httpResponse = response as? HTTPURLResponse {
                print("\nResponse Headers:")
                print(httpResponse.allHeaderFields)
                print("\nStatus Code: \(httpResponse.statusCode)")
                
                guard httpResponse.statusCode == 200 else {
                    completion?(.failure(.errorAnswerCode(httpResponse.statusCode)))
                    return
                }
            }
            
            // Обработка данных
            guard let data = data else {
                print("Нет данных")
                completion?(.failure(.dataIsNil))
                return
            }
            
            // Преобразование в String
            if let dataString = String(data: data, encoding: .utf8) {
                print("\nДанные (String):")
                print(dataString)
            }
            
            // Парсинг JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let json = json else {
                    completion?(.failure(.dataIsNil))
                    return
                }
                completion?(.success(json))
            } catch {
                print("Ошибка парсинга JSON: \(error.localizedDescription)")
                completion?(.failure(.jsonParsingError(error)))
            }
        }
        
        task.resume()
    }
}
