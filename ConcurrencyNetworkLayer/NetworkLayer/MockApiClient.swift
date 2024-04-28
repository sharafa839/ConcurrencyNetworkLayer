//
//  MockApiClient.swift
//  ConcurrencyNetworkLayer
//
//  Created by Sharaf on 4/28/24.
//

import Foundation

class MockAPiClient: Mockable, ApiClientProtocol {
    func request<T>(apiProvider: ApiProvider, response: T.Type) async throws -> T where T : Decodable {
        loadJson(fileName: apiProvider.mockFile ?? "", type: response.self)
    }
}
