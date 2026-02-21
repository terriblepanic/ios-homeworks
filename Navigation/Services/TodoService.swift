//
//  TodoService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/21/26.
//

import Foundation

enum TodoError: Error {
    case invalidURL
    case dataIsNil
    case jsonParsingError
    case mappingError
    case networkError(Error)
}

struct TodoService {
    
    static func fetchTodo(id: Int = 5, completion: @escaping (Result<Todo, TodoError>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("\n[TodoService] Запрос: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Обработка ошибки
            if let error = error {
                print("[TodoService] Ошибка: \(error.localizedDescription)")
                completion(.failure(.networkError(error)))
                return
            }
            
            // Обработка данных
            guard let data = data else {
                print("[TodoService] Нет данных")
                completion(.failure(.dataIsNil))
                return
            }
            
            // Парсинг JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                guard let json = json else {
                    print("[TodoService] JSON не является словарем")
                    completion(.failure(.jsonParsingError))
                    return
                }
                
                print("[TodoService] JSON получен: \(json)")
                
                guard let todo = Todo(from: json) else {
                    print("[TodoService] Не удалось создать Todo")
                    completion(.failure(.mappingError))
                    return
                }
                
                print("[TodoService] Todo создан: \(todo.title)")
                completion(.success(todo))
                
            } catch {
                print("[TodoService] Ошибка парсинга: \(error.localizedDescription)")
                completion(.failure(.jsonParsingError))
            }
        }
        
        task.resume()
    }
}
