//
//  APIService.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 10.09.2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case unknown(Error)
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String]?,
        parameters: [String: Any]?,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() { }

    private let baseURL = "https://api.themoviedb.org/3/"

    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String]?,
        parameters: [String: Any]?,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + path) else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                DispatchQueue.main.async { completion(.failure(.unknown(error))) }
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(.unknown(error))) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async { completion(.failure(.serverError(httpResponse.statusCode))) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(responseType, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError(error))) }
            }
        }.resume()
    }
}
    
    

