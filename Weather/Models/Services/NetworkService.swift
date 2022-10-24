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
                
                if let _response = response as? HTTPURLResponse,
                   (200..<300).contains(_response.statusCode) {
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
                    completionHandler(.failure(NetworkError.failedResponse))
                    NSLog("Failed network response \(response!.description)")
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
        case failedResponse
        case failedRequest
        case emptyData
    }
}
