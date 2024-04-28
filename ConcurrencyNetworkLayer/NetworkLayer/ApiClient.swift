//
//  ApiClient.swift
//  ConcurrencyNetworkLayer
//
//  Created by Sharaf on 4/28/24.
//

import Foundation

protocol ApiClientProtocol {
    
    func request<T:Decodable>(apiProvider: ApiProvider, response: T.Type) async throws ->  T
}

final class ApiClient: ApiClientProtocol {
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 300
        var urlSession = URLSession(configuration: configuration)
        return urlSession
    }
    
    func request<T>(apiProvider: ApiProvider, response: T.Type) async throws -> T where T : Decodable {
        do {
            let (data, response) = try await session.data(for: apiProvider.asURLRequest())
            return try manageResponse(data: data, response: response)
        }
    }
    
    func manageResponse<T:Decodable> (data: Data, response: URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw ApiError.init(errorCode: "Error", message: "invalidResponse")
        }
        let statusCode = response.statusCode
        
        switch statusCode {
        case 200 ... 299 :
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw ApiError.init(errorCode: "error" , message: "errorDecodingData")
            }
        default:
            guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                throw ApiError(statusCode: response.statusCode,
                               errorCode: "ERROR",
                               message: "UnknownBackendError")
            }
            throw ApiError(statusCode: response.statusCode,
                           errorCode: decodedError.errorCode,
                           message: decodedError.message)
        }
    }
}
