//
//  ApiProvider.swift
//  ConcurrencyNetworkLayer
//
//  Created by Sharaf on 4/28/24.
//

import Foundation

protocol ApiProvider {
    var scheme: String { get }
    var method: RequestMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var header: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var mockFile: String? { get }
}

extension ApiProvider {
    
    func asURLRequest() -> URLRequest {
        var urlComponents =  URLComponents()
        urlComponents.path = path
        urlComponents.scheme = scheme
        urlComponents.host = baseURL
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                
            }
        }
        return urlRequest
    }
}
