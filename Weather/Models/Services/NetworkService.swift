//
//  NetworkService.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import Foundation

protocol Endpoint {
    func asURL() throws -> URL
}

protocol NetwrorkService {
    func request<Response: Decodable>(_ endpoint: Endpoint,
                                      jsonDecoder: JSONDecoder,
                                      completionHandler: @escaping (Result<Response, Error>) -> Void)
}

class NetworkServiceImpl: NetwrorkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<Response: Decodable>(_ endpoint: Endpoint,
                                      jsonDecoder: JSONDecoder,
                                      completionHandler: @escaping (Result<Response, Error>) -> Void) {
        do {
            let url = try endpoint.asURL()
            session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completionHandler(.failure(NetworkError.failedRequest))
                    NSLog("Failed to make request with error, \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(NetworkError.invalidResponseType))
                    NSLog("Invalid response type, \(type(of: response.self))")
                    return
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    guard let _data = data else {
                        completionHandler(.failure(NetworkError.emptyData))
                        NSLog("Request did finish with empty data")
                        return
                    }
                    
                    do {
                        let decodedData = try jsonDecoder.decode(Response.self, from: _data)
                        completionHandler(.success(decodedData))
                    } catch {
                        completionHandler(.failure(NetworkError.failedDecoding))
                        NSLog("Failed to decode data, \(error)")
                    }
                } else {
                    completionHandler(.failure(NetworkError.invalidHTTPStatusCode))
                    NSLog("Invalid response status code \(httpResponse.statusCode)")
                }
            }.resume()
        } catch {
            completionHandler(.failure(NetworkError.failedEndpoint))
            NSLog("Failed to represent endpoint to URL, \(error)")
        }
    }
    
}

extension NetworkServiceImpl {
    enum NetworkError: Error {
        case failedEndpoint
        case failedDecoding
        case failedRequest
        case invalidResponseType
        case invalidHTTPStatusCode
        case emptyData
    }
}
