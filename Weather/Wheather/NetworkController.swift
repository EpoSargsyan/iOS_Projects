//
//  NetworkController.swift
//  Wheather
//
//  Created by Eprem Sargsyan on 14.04.23.
//

import Foundation

struct NetworkCOntroller {
    public static var baseURL = "api.openweathermap.org"
    private static let apiKey = "62c7f8e30925ae21afce11e4e814c889"
    
    enum endPoint {
        case cityId(path: String = "/data/2.5/weather", id:Int)
        
        var url : URL? {
            var components = URLComponents()
            
            components.scheme = "https"
            components.host = baseURL
            components.path = path
            components.queryItems = queryItems
            
            return components.url
        }
        
        private var path: String {
            switch self {
            case .cityId(let path, _):
                return path
            }
        }
        
        var queryItems : [URLQueryItem] {
            
            var queryItems = [URLQueryItem]()
            
            switch self {
            case .cityId(_, let id) :
                queryItems.append(URLQueryItem(name: "id", value: String(id)))
            }
            
            queryItems.append(URLQueryItem(name: "appid", value: apiKey))
            
            return queryItems
        }
    }
    
    static func fetchWheater(for cityId: Int, _ completion: @escaping ((Weather) -> Void)) {
        
        if let url = endPoint.cityId(id: cityId).url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error {
                    print(error)
                }
                
                if let data = data {
                    do {
                        let weather = try JSONDecoder().decode(Weather.self, from: data)
                        completion(weather)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
